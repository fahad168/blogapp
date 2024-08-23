require 'csv'

class SizeConversionService
  def initialize(params)
    @from = params[:initial_national]
    @to = params[:target_national]
    @size = params[:size]
    @file_path = Rails.root.join('public/sizing.csv')
  end

  def read_csv
    csv_data = CSV.read(@file_path, headers: true)
    size_chart = {}
    csv_data.each do |row|
      locale = row[0]&.downcase
      next if locale.nil?
      sizes = row.fields[1..-1]&.map { |size| size&.downcase }
      size_chart[locale] = sizes
    end
    convert_size(size_chart)
  end

  private

  def convert_size(size_chart)
    from_size = size_chart[@from]
    to_size = size_chart[@to]

    size_index = from_size.index(@size)
    return nil if to_size.nil?

    to_size[size_index]
  end
end