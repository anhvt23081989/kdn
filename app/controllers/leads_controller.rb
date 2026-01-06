class LeadsController < Public::BaseController
  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to root_path, notice: "Cảm ơn bạn đã đăng ký! Chúng tôi sẽ liên hệ với bạn sớm nhất." }
        format.json { render json: { success: true, message: "Cảm ơn bạn đã đăng ký! Chúng tôi sẽ liên hệ với bạn sớm nhất." } }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @lead.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :address, :message, :source)
  end
end

