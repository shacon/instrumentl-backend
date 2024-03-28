require 'csv'
require 'date'

namespace :restaurant_data do 

	desc "Import Restaurant Data from CSV into DB models"
	task :import, [:file_path] => :environment do |task, args|
		file_path = args[:file_path]
		puts "Starting Import"
		puts file_path
		ActiveRecord::Base.transaction do
			CSV.foreach(file_path, headers:true) do |row|
				# For each of these records, save and add data to the record only if it's a new one
				@owner = Owner.find_or_initialize_by(name: row['owner_name'])
	      if @owner.new_record?
		      @owner.address = row['owner_address']
					@owner.city = row['owner_city']
					@owner.state = row['owner_state']
					@owner.zip = row['owner_zip']
		      @owner.save!
		    end

		    @restaurant = Restaurant.find_or_initialize_by(name: row['name'])
		    if @restaurant.new_record?
				  @restaurant.address = row['address']
				  @restaurant.city = row['city']
				  @restaurant.phone_number = row['phone_number']
				  @restaurant.zip = row['zip']
				  @restaurant.owner = @owner
				  @restaurant.save!
				 end

				insp_date_object = DateTime.strptime(row['inspection_date'], '%Y%m%d')
				@inspection = Inspection.find_or_initialize_by(inspection_type: row['inspection_type'],
																											 date: insp_date_object,
																											 score: row['inspection_score'])
				if @inspection.new_record?
			    @inspection.date = insp_date_object
			    @inspection.score = row['inspection_score']
			    @inspection.inspection_type = row['inspection_type']
			    @inspection.restaurant = @restaurant
			    @inspection.save!
				end

				@risk_category = RiskCategory.find_or_initialize_by(name: row['risk_category'])
				if @risk_category.new_record?
			    @risk_category.name = row['risk_category']
			    @risk_category.save!
				end

				insp_violation_date_object = DateTime.strptime(row['violation_date'], '%Y%m%d')
				@violation = InspectionViolation.find_or_initialize_by(violation_type: row['violation_type'],
																															 date: insp_violation_date_object,
																															 description: row['description'],
																															 inspection: @inspection)

				if @violation.new_record?
			    @violation_date = insp_violation_date_object			    
			    @violation.violation_type = row['violation_type']
			    @violation.inspection = @inspection
			    @violation.risk_category = @risk_category
			    @violation.save!
				end

			rescue => e
		    puts "Error processing CSV file: #{e.message}"
		  end
		 end
	end


	desc "Remove all Restaurant Data from Database"
	task remove_all_data: :environment do
		InspectionViolation.all.destroy_all
		Inspection.all.destroy_all
		RiskCategory.all.destroy_all
		Restaurant.all.destroy_all
		Owner.all.destroy_all
	end

end