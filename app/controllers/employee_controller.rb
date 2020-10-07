class EmployeeController < ApplicationController

    get '/employees/new' do
        if Helpers.is_logged_in?(session)
          redirect '/home'
        else
          erb :"/employees/new"
        end
      end
    
      post '/employees/new' do
        @employee = Employee.find_by(email: params[:email])
        if @employee == nil
          params.each do |param|
            if param[1].empty?
              redirect '/employees/new'
            else
            end
          end
          new_employee = Employee.new(first_name: params[:first_name], last_name: params[:last_name], job_title: params[:job_title], email: params[:email], birthdate: params[:birthdate], password: params[:password])
          new_employee.store_id = Store.find_by(location: params[:job_location]).id
          new_employee.save
          session[:id] = new_employee.id
          redirect "/home"
        else
          redirect '/employees/new'
        end
      end

end