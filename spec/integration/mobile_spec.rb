require 'swagger_helper'

describe 'Mobile Apps API' do
  
  path '/api/mobile/sign_in' do

    post 'Visitor Login' do
        tags 'Mobile'
        consumes 'application/json'
        parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          phone_mobile: { type: :string },
          pin_c: {type: :string},
          type: {type: :string}
        },
        required: [ 'phone_mobile', 'pin_c', 'type' ]
        }

        response '200', 'Success' do
          let(:json) { {visitor: {first_name:'', last_name:'', phone_num:''}, type:"Visitor/Vendor"}  }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Missing Phone number' }
          run_test!
        end
    end
  end

  path '/api/mobile/forgot_pin' do

    post 'Validate Phone number' do
        tags 'Mobile'
        consumes 'application/json'
        parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          phone_mobile: { type: :string }
        },
        required: [ 'phone_mobile' ]
        }

        response '200', 'Verification code sent' do
          let(:json) { {otp: otp, message:"Verification code sent"} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Invalid Phone number' }
          run_test!
        end
    end
  end

  path '/api/mobile/reset_pin' do

    post 'Reset pin' do
        tags 'Mobile'
        consumes 'application/json'
        parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          phone_mobile: { type: :string },
          pin_c: {type: :string}
        },
        required: [ 'phone_mobile', 'pin_c' ]
        }

        response '200', 'Pin updated successfully' do
          let(:json) { {message:"Pin updated successfully"} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Invalid Phone number' }
          run_test!
        end
    end
  end

  path '/api/mobile/set_personal_details' do

    post 'Set/update personal details of visitor/vendor' do
        tags 'Mobile'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
         properties: {
          registrant:{ type: :object,
            properties: {
              first_name: { type: :string },
              last_name: {type: :string},
              email: { type: :string },
              vendor_company_id: {type: :integer}
            }
          }
        },
        required: [ 'vendor_company_id']
        }

        response '200', 'Success' do
          let(:json) { {visitor: {first_name:'', last_name:'', phone_num:''}, type:"Visitor/Vendor"} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Missing Visitor id' }
          run_test!
        end
    end
  end


  path '/api/mobile/my_customers' do

    get 'Customers of a particular vendor' do
      tags 'Mobile'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
       
      response '200', 'Success' do
           schema type: :array,
          properties: {
            customers:{ type: :object,
              properties: {
                id: { type: :integer },
                name: {type: :string},
                date_entered: { type: :string },
                date_modified: { type: :string },
                owner_id: { type: :integer },
                us_state_id: { type: :integer },
                status_c: {type: :string},
                avatar_url: {type: :string}
                
              }
            },
            
            status: {type: :integer}
          }

        let(:'auth') { '<token-here>' }
        run_test!
      end

      response '404', 'Invalid Token' do
        let(:'auth') { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/mobile/my_visits' do
    get 'Visits of vendor by industry' do
      tags 'Mobile'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :company_id, in: :query, type: :string, required: true, description: ''
      response '200', 'Success' do
           schema type: :array,
          properties: {
            customers:{ type: :object,
              properties: {
                id: { type: :integer },
                person_name: {type: :string},
                on_date: { type: :string },
                visit_status: { type: :string },
                visit_entry_type: { type: :integer },
                event_id: { type: :string },
                qrcode_id: {type: :string},
                tentative_datetime: {type: :string},
                on_date_time: { type: :string },
                end_date_time: {type: :string}
                
              }
            },
            
            status: {type: :integer}
          }

        let(:'auth') { '<token-here>' }
        run_test!
      end

      response '404', 'Invalid Token' do
        let(:'auth') { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/mobile/departments' do

    get 'Departments of an industry' do
      tags 'Mobile'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :company_id, in: :query, type: :string, required: true
        
      response '200', 'Success' do
           schema type: :array,
          properties: {
            departments:{ type: :object,
              properties: {
                  id: { type: :integer },
                  name: {type: :string},
                  code: { type: :string },
                  company_id: { type: :integer }
              }
            },
            status: {type: :integer}
          }

        let(:'auth') { '<token-here>' }
        run_test!
      end

      response '404', 'Invalid Token' do
        let(:'auth') { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/mobile/new_visit' do

    post 'New visit request' do
        tags 'Mobile'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
         properties: {
          entries:{ type: :object,
            properties: {
              tentative_datetime: { type: :string },
              person_name: { type: :string },
              department_id: { type: :integer },
              triggered_by_os: { type: :string },
              send_message: {type: :boolean},
              person_contact: {type: :string},
              visit_notes: {type: :string}
            }
          }
        },
        required: [ 'visitor_type', 'visit_entry_type', 'visitor_id' ]
        }

        response '200', 'Success' do
          let(:json) { {"visit":{"id":1,"visitor_type":"Vendor","visitor_id":1,"department_id":2,"department_name":"Admin Department","visit_status":"current","person_name":null,"event_id":null,"qrcode_id":"7815ad90-91d5-4dd9-a0f1-3f99c1057f5d-1558100082543","tentative_datetime":null,"event_date_time":"2019-05-17T06:30:48.102Z","date_entered":"2019-05-17T13:34:42.663Z","date_modified":"2019-05-17T13:34:42.663Z"}} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Missing mandatory params' }
          run_test!
        end
    end
  end


  path '/api/mobile/agreements' do

    get 'Industry Agreements accepted by Vendor' do
      tags 'Mobile'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :company_id, in: :header, type: :string, required: true
        
      response '200', 'Success' do
           schema type: :array,
          properties: {
            agreements:{ type: :object,
              properties: {
                  id: { type: :integer },
                  title: {type: :string},
                  description: { type: :string },
                  url: { type: :string },
                  company_id: { type: :integer }
              }
            },
            status: {type: :integer}
          }

        let(:'auth') { '<token-here>' }
        run_test!
      end

      response '404', 'Invalid Token' do
        let(:'auth') { 'invalid' }
        run_test!
      end
    end
  end
  
  path '/api/mobile/notes' do

    get 'Visit Notes' do
      tags 'Mobile'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :visit_id, in: :header, type: :string, required: true
        
      response '200', 'Success' do
           schema type: :array,
          properties: {
            notes:{ type: :object,
              properties: {
                  id: { type: :integer },
                  before_visit: {type: :string},
                  after_visit: { type: :string },
                  visit_id: { type: :integer }
              }
            },
            status: {type: :integer}
          }

        let(:'auth') { '<token-here>' }
        run_test!
      end

      response '404', 'Invalid Token' do
        let(:'auth') { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/mobile/update_notes' do

    post 'Update existing visit notes' do
        tags 'Mobile'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
         properties: {
            notes_id: { type: :integer },
            before_visit: {type: :string},
            after_visit: { type: :string }          
        },
        required: [ 'notes_id']
        }

        response '200', 'Success' do
          let(:json) { {visit_notes: {before_visit:'', after_visit:''}} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Missing notes id' }
          run_test!
        end
    end
  end


end
