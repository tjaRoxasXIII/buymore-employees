class EmployeeController < ApplicationController

    get '/employees/new' do
        if Helpers.is_logged_in?(session)
            redirect '/home'
        else
            erb :"/employees/new"
        end
    end

    post '/employees/new' do
        new_employee = Employee.new(params[:employee])
        new_employee.store_id = Store.find_by(location: params[:job_location]).id
        if new_employee.save
            session[:id] = new_employee.id
            redirect "/home"
        else
            redirect '/employees/new'
        end
    end

    get '/employees/:id/profile' do
        if Helpers.is_logged_in?(session)
            @employee = Employee.find_by(id: params[:id])
            erb :"/employees/profile"
        else
            redirect '/'
        end
    end

    post '/employees/:id/profile' do
        @employee = Employee.find_by(id: params[:id])
        @employee.photo = params[:img]
        @employee.save
        erb :"/employees/profile"
    end

    get '/employees/:id/profile/edit' do
        @employee = Employee.find_by(id: params[:id])
        if Helpers.is_logged_in?(session) && @employee.id == session[:id]   
            erb :"/employees/edit"
        else
            redirect '/'
        end
    end

    patch '/employees/:id/profile/edit' do
        @employee = Employee.find_by(id: params[:id])
        @employee.email = params[:email]
        @employee.password = params[:password]
        @employee.save
        erb :"/employees/profile"
    end

    get '/employees/:id/delete' do
        @employee = Employee.find_by(id: params[:id])
        if Helpers.is_logged_in?(session) && @employee.id == session[:id]
            erb :"/employees/delete"
        else
            redirect '/'
        end

    end

    delete '/employees/:id/delete' do
        if Helpers.is_logged_in?(session)
          @employee = Employee.find_by(id: params[:id])
          session.clear
          @employee.updates.all.each {|post| post.delete}
          @employee.delete
          redirect '/home'
        else
          redirect '/'
        end
    end
    
end