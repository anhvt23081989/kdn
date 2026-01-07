// Public site JavaScript - Minimal JS as per project rules

// Catalogue Modal Functions
function openCatalogueModal() {
  const modal = document.getElementById('catalogueModal');
  if (modal) {
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
  }
}

function closeCatalogueModal() {
  const modal = document.getElementById('catalogueModal');
  if (modal) {
    modal.style.display = 'none';
    document.body.style.overflow = '';
    // Reset form
    const form = document.getElementById('catalogueForm');
    if (form) form.reset();
    // Hide messages
    const errorsDiv = document.getElementById('formErrors');
    const successDiv = document.getElementById('formSuccess');
    if (errorsDiv) errorsDiv.classList.add('hidden');
    if (successDiv) successDiv.classList.add('hidden');
  }
}

// Tab switching function
function switchTab(categorySlug, tabSlug, categoryId) {
  // Update active tab button (for both horizontal and vertical menus)
  const buttons = document.querySelectorAll(`[data-category="${categorySlug}"].tab-button`);
  buttons.forEach(btn => {
    btn.classList.remove('active', 'border-blue-600', 'text-blue-600', 'bg-blue-50');
    btn.classList.add('text-gray-600', 'text-gray-700');
    // Remove active styles
    if (btn.classList.contains('ux-menu-link__link')) {
      btn.classList.remove('text-blue-600', 'bg-blue-50');
      btn.classList.add('text-gray-700');
    }
  });
  const activeButton = document.querySelector(`[data-category="${categorySlug}"][data-tab="${tabSlug}"]`);
  if (activeButton) {
    activeButton.classList.add('active');
    if (activeButton.classList.contains('ux-menu-link__link')) {
      // Vertical menu button
      activeButton.classList.add('text-blue-600', 'bg-blue-50');
      activeButton.classList.remove('text-gray-700');
    } else {
      // Horizontal tab button
      activeButton.classList.add('border-blue-600', 'text-blue-600');
      activeButton.classList.remove('border-transparent', 'text-gray-600');
      activeButton.style.borderBottomColor = '#2563eb';
      activeButton.style.color = '#2563eb';
    }
  }

  // Hide all tab contents for this category
  document.querySelectorAll(`.product-grid-${categorySlug} .tab-content`).forEach(c => {
    c.classList.add('hidden');
    c.classList.remove('active');
  });

  // Show active tab content
  const contentDiv = document.getElementById(`products-${categorySlug}-${tabSlug}`);
  if (contentDiv) {
    contentDiv.classList.remove('hidden');
    contentDiv.classList.add('active');
  }

  // Load products if not "all" tab
  if (tabSlug !== 'all' && contentDiv && contentDiv.textContent.includes('Đang tải')) {
    loadCategoryProducts(categorySlug, tabSlug, categoryId);
  }
}

// Load products for subcategory
function loadCategoryProducts(categorySlug, subcategorySlug, categoryId) {
  const contentDiv = document.getElementById(`products-${categorySlug}-${subcategorySlug}`);
  if (!contentDiv) return;

  fetch(`/san-pham?category_id=${categoryId}&format=json`)
    .then(response => response.json())
    .then(data => {
      if (data.products && data.products.length > 0) {
        contentDiv.innerHTML = `
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
            ${data.products.map(product => `
              <div class="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-all duration-300 group">
                <div class="relative overflow-hidden">
                  ${product.image_url ? `<a href="/san-pham/${product.slug}"><img src="${product.image_url}" alt="${product.name}" class="w-full h-48 md:h-56 object-cover group-hover:scale-105 transition-transform duration-300"></a>` : '<div class="w-full h-48 md:h-56 bg-gray-100 flex items-center justify-center"><span class="text-gray-400 text-sm">Không có ảnh</span></div>'}
                  ${product.is_new ? '<span class="absolute top-2 right-2 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded">NEW</span>' : ''}
                </div>
                <div class="p-4">
                  <h3 class="font-semibold text-sm md:text-base mb-2 line-clamp-2 min-h-[3rem]">
                    <a href="/san-pham/${product.slug}" class="hover:text-blue-600 text-gray-800 transition-colors">${product.name}</a>
                  </h3>
                  ${product.sku ? `<p class="text-gray-500 text-xs font-mono">SKU: ${product.sku}</p>` : ''}
                </div>
              </div>
            `).join('')}
          </div>
        `;
      } else {
        contentDiv.innerHTML = '<div class="col-span-4 text-center text-gray-500 py-12"><p class="text-lg">Chưa có sản phẩm</p></div>';
      }
    })
    .catch(error => {
      console.error('Error loading products:', error);
      contentDiv.innerHTML = '<div class="col-span-4 text-center text-red-500 py-8">Lỗi khi tải sản phẩm</div>';
    });
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', function() {
  // Close modal on outside click
  const modal = document.getElementById('catalogueModal');
  if (modal) {
    modal.addEventListener('click', function(e) {
      if (e.target === this) {
        closeCatalogueModal();
      }
    });
  }

  // Handle catalogue form submission
  const form = document.getElementById('catalogueForm');
  if (form) {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      const formData = new FormData(form);
      const errorsDiv = document.getElementById('formErrors');
      const errorList = document.getElementById('errorList');
      const successDiv = document.getElementById('formSuccess');

      // Hide previous messages
      if (errorsDiv) errorsDiv.classList.add('hidden');
      if (successDiv) successDiv.classList.add('hidden');
      if (errorList) errorList.innerHTML = '';

      fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content || '',
          'Accept': 'application/json'
        }
      })
      .then(response => {
        if (response.ok) {
          return response.json();
        }
        return response.json().then(err => Promise.reject(err));
      })
      .then(data => {
        if (data.success) {
          if (successDiv) successDiv.classList.remove('hidden');
          form.reset();
          setTimeout(() => {
            closeCatalogueModal();
          }, 2000);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        if (error.errors) {
          const errorMessages = Object.values(error.errors).flat();
          if (errorList) {
            errorList.innerHTML = errorMessages.map(err => `<li>${err}</li>`).join('');
          }
          if (errorsDiv) errorsDiv.classList.remove('hidden');
        } else {
          if (errorList) errorList.innerHTML = '<li>Có lỗi xảy ra. Vui lòng thử lại sau.</li>';
          if (errorsDiv) errorsDiv.classList.remove('hidden');
        }
      });
    });
  }

  // User dropdown toggle
  const userDropdownButton = document.querySelector('.user-dropdown button');
  const userDropdown = document.getElementById('userDropdown');
  
  if (userDropdownButton && userDropdown) {
    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
      const isClickInside = userDropdown.contains(event.target) || userDropdownButton.contains(event.target);
      if (!isClickInside) {
        userDropdown.classList.add('hidden');
        userDropdown.classList.remove('show');
      }
    });
  }
});

// Toggle user dropdown
function toggleUserDropdown() {
  const dropdown = document.getElementById('userDropdown');
  if (dropdown) {
    dropdown.classList.toggle('hidden');
    dropdown.classList.toggle('show');
  }
}

// Toggle search overlay
function toggleSearch() {
  const searchOverlay = document.getElementById('searchOverlay');
  if (searchOverlay) {
    searchOverlay.classList.toggle('hidden');
    if (!searchOverlay.classList.contains('hidden')) {
      const input = searchOverlay.querySelector('input[type="text"]');
      if (input) input.focus();
    }
  }
}

