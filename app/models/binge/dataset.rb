require 'csv'

module Binge
  class Dataset
    include ActiveModel::Model
    extend CarrierWave::Mount
    include CarrierWave::Validations::ActiveModel

    attr_accessor :data_file, :model
    mount_uploader :data_file, DataUploader

    def initialize(attributes = {})
      if attributes[:model_class_name]
        model_class_name   = attributes.delete(:model_class_name)
        attributes[:model] = Model.find(model_class_name)
      end

      super(attributes)
    end

    validates :model, presence: {message: "Model can't be blank"}
    validates_integrity_of :data_file
    validates :data_file, presence: {message: "Data file can't be blank"}, unless: "data_file_integrity_error"
    validate :atleast_one_row, unless: "data_file.blank?"
    validate :header_matches_model_attributes, unless: "data_file.blank? or model.blank?"

    def model_class_name
      model.class_name
    end

    def import_valid
      importer = CsvImporter.new(self)
      importer.import
    end

    private

    def csv
      @csv ||= CSV.parse(data_file.read)
    end

    def atleast_one_row
      self.errors.add(:data_file, "The file should have atleast one data row") if csv.to_a.size <= 1
    end

    def header_matches_model_attributes
      rows = csv.to_a
      return if rows.empty?

      headers = rows.first.collect(&:strip)
      missing_columns = model.columns.reject {|column| headers.include?(column.name)}
      missing_column_names = missing_columns.collect(&:name).join(", ")
      return if missing_columns.empty?
      self.errors.add(:data_file, "The file does not have the following required columns: #{missing_column_names}")
    end
  end
end
