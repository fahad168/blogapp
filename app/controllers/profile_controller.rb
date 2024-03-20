class ProfileController < ApplicationController

  before_action :authenticate_user!

  def index
    @addresses = current_user.addresses.all
  end

  def update
    delete_address if params[:deletedAddressIds].present?
    current_user.profile.update(profile_params.merge(gender: params[:gender] == 'Select Gender' ? nil : params[:gender]))
    if params[:countries].present?
      params[:countries].each_with_index do |country, index|
        Address.create(countries: country,
                       states: params[:states][index],
                       cities: params[:cities][index],
                       zipcode: params[:zipcode][index],
                       street_address: params[:street_address].present? ? params[:street_address][index] : nil,
                       apartment_number: params[:apartment_number].present? ? params[:apartment_number][index] : nil,
                       user_id: current_user.id
        )
      end
    end
    flash[:notice] = "Changes saved successfully"
    redirect_to profile_path
  end

  def states
    country = ISO3166::Country.find_country_by_alpha2(params[:country])
    states = country.subdivision_names_with_codes
    render json: { states: states }, status: :ok
  end

  def cities
    country_code = ISO3166::Country.find_country_by_iso_short_name(params[:country])
    state = find_city_code(country_code.subdivision_names_with_codes, params[:state])
    cities = CS.cities(state&.second&.to_sym, country_code.alpha2&.to_sym)
    render json: { cities: cities }, status: :ok
  end

  def country_select
    render json: { entries: render_to_string(partial: 'profile/country_select', formats: [:html]) }
  end

  private

  def profile_params
    params.permit(:first_name, :last_name, :phone_number, :profile_image)
  end

  def find_city_code(array, state)
    array.each do |subarray|
      return subarray if subarray.first == state
    end
    nil
  end

  def delete_address
    Address.where(id: JSON.parse(params[:deletedAddressIds])).destroy_all
  end
end
