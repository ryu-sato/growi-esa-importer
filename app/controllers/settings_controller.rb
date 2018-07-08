class SettingsController < InheritedResources::Base
  before_action :set_post, only: [:edit, :update]

  # GET /setting/edit
  def edit
  end

  # PATCH/PUT /setting/
  # PATCH/PUT /setting.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to edit_setting_path, notice: 'setting was successfully updated.' }
        format.json { render :edit, status: :ok, location: edit_setting_path }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      if Setting.count == 0
        Setting.create()
      elsif Setting.count > 1
        raise 'More than two settings exists.'
      end
      @setting = Setting.first
    end

    def setting_params
      params.require(:setting).permit(:esa_access_token, :esa_team, :crowi_access_token, :crowi_url)
    end
end

