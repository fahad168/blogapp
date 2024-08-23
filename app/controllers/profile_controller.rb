class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def update
    if current_user.profile.update(profile_params)
      flash[:notice] = "Changes saved successfully"
      redirect_to profile_index_path
    end
  end

  def blogger_profile
    if params[:type] == 'JS'
      render json: { entries: render_to_string(partial: 'profile/blogger_profile'), format: [:html] }
    else
    end
  end

  def blogger_profile_edit
    current_user.profile.update(profile_params) if params[:profile_image].present? || params[:gender].present?
    blogger_params = blogger_profile_params
    blogger_params = blogger_params.merge(location: params[:location]) if params[:location].present?
    blogger_params = blogger_params.merge(languages: JSON.parse(params[:languages])) if params[:languages].present?
    current_user.blogger_profile.update(blogger_params)
    render json: { entries: render_to_string(partial: params[:type] == 'additional_details' ? 'profile/additional_details_section_data' : 'profile/profile_top_section_data'), format: [:html] }
  end

  def add_education
    education_params_updated = education_params
    education_params_updated.merge!(skills: JSON.parse(params[:skills])) if params[:skills].present?

    @education = params[:educational_id].present? ? Education.find_by(id: params[:educational_id]) : Education.new

    if @education.update(education_params_updated)
      render json: { entries: render_to_string(partial: 'profile/educations_content', formats: [:html]) }
    end
  end

  def add_project
    project_params_updated = project_params
    project_params_updated.merge!(skills: JSON.parse(params[:skills])) if params[:skills].present?

    @education = params[:project_id].present? ? Project.find_by(id: params[:project_id]) : Project.new

    if @education.update(project_params_updated)
      render json: { entries: render_to_string(partial: 'profile/projects_content', formats: [:html]) }
    end
  end

  def delete_education
    @education = Education.find_by(id: params[:id])
    if @education.destroy
      render json: { entries: render_to_string(partial: 'profile/educations_content'), format: [:html] }
    end
  end

  def delete_project
    @project = Project.find_by(id: params[:id])
    if @project.destroy
      render json: { entries: render_to_string(partial: 'profile/projects_content'), format: [:html] }
    end
  end

  private

  def profile_params
    params.permit(:first_name, :last_name, :gender, :number, :profile_image)
  end

  def blogger_profile_params
    params.permit(:job_title, :location, :cover_image, :summary, :nickname ,languages: [])
  end

  def education_params
    params.permit(:school, :degree, :field_of_study, :start_date, :end_date, :grade, skills: []).merge(blogger_profile_id: current_user.blogger_profile.id)
  end

  def project_params
    params.permit(:name, :description, :start_date, :end_date, :checked, skills: []).merge(blogger_profile_id: current_user.blogger_profile.id)
  end
end