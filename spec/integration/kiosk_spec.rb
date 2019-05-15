require 'swagger_helper'

describe 'Kiosk API' do

  path '/api/kiosk/device' do

    get 'Device details' do
      tags 'Kiosk'
      produces 'application/json'
      parameter name: :auth, in: :header, type: :string, required: true
      parameter name: :serial, in: :query, type: :string, required: true, description: ''
        
      response '200', 'Success' do
           schema type: :array,
          properties: {
            company:{ type: :object,
              properties: {
                id: { type: :integer },
                name: {type: :string},
                date_entered: { type: :string },
                date_modified: { type: :string },
                company_id: { type: :integer },
                building_id: { type: :integer },
                building_name: { type: :string },
                identifier: { type: :string },
                identifier_type: { type: :string },
                printer_status_c: { type: :string },
                printer_conn_c: { type: :string },
                status_c: {type: :string}
                
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

  path '/api/kiosk/company' do

    get 'Company details' do
      tags 'Kiosk'
      produces 'application/json'
      parameter name: :auth, in: :header, type: :string, required: true
      parameter name: :sugar_id, in: :query, type: :string, required: true, description: ''
        
      response '200', 'Success' do
           schema type: :array,
          properties: {
            company:{ type: :object,
              properties: {
                id: { type: :integer },
                name: {type: :string},
                date_entered: { type: :string },
                date_modified: { type: :string },
                kiosk_count: { type: :integer },
                owner_id: { type: :integer },
                us_state_id: { type: :integer },
                status_c: {type: :string}
                
              }
            },
            
            status: {type: :integer}
          }

        let(:'auth') { 'Bearer <token-here>' }
        run_test!
      end

      response '404', 'Invalid Token' do
        let(:'auth') { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/kiosk/verify_phone' do

    post 'Validate Phone number' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
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
           let(:json) { 'Missing Phone number' }
          run_test!
        end
    end
  end

  path '/api/kiosk/register_visitor' do

    post 'First time vendor/family registration' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
         properties: {
          registrant:{ type: :object,
            properties: {
              phone_mobile: { type: :string },
              vendor_pin_c: {type: :integer}
            }
          },
          type: {type: :string}

        },
        required: [ 'phone_mobile', 'vendor_pin_c', 'type' ]
        }

        response '200', 'Success' do
          let(:json) { {visitor: {first_name:'', last_name:'', phone_num:''}, type:"Visitor/Vendor"} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Missing Phone number' }
          run_test!
        end
    end
  end
  
  path '/api/kiosk/vendor_companies' do

    get 'Vendor Companies of industry' do
      tags 'Kiosk'
      produces 'application/json'
      parameter name: :auth, in: :header, type: :string, required: true
      parameter name: :device_id, in: :header, type: :string, required: true
        
      response '200', 'Success' do
           schema type: :array,
          properties: {
            vendor_companies:{ type: :object,
              properties: {
                  id: { type: :integer },
                  name: {type: :string},
                  created_at: { type: :string },
                  updated_at: { type: :string },
                  phone_num: { type: :string },
                  email: { type: :string },
                  us_state_id: { type: :integer },
                  address1: {type: :string},
                  address2: {type: :string}
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

  path '/api/kiosk/set_personal_details' do

    post 'Set/update personal details of visitor/vendor' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
         properties: {
          registrant:{ type: :object,
            properties: {
              visitor_id: {type: :integer},
              first_name: { type: :string },
              last_name: {type: :string},
              email: { type: :string },
              vendor_company_id: {type: :integer}
            }
          },
          type: {type: :string}

        },
        required: [ 'visitor_id', 'vendor_company_id', 'type' ]
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
  
  path '/api/kiosk/agreements' do

    get 'Industry Agreements' do
      tags 'Kiosk'
      produces 'application/json'
      parameter name: :auth, in: :header, type: :string, required: true
      parameter name: :device_id, in: :header, type: :string, required: true
        
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

  path '/api/kiosk/accept_agreements' do

    post 'Accept industry agreements by vendor' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          vendor_id: { type: :integer }
        },
        required: [ 'vendor_id' ]
        }

        response '200', 'Success' do
          let(:json) { {message:"Success"} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Missing Vendor id' }
          run_test!
        end
    end
  end

  path '/api/kiosk/departments' do

    get 'Departments of an industry' do
      tags 'Kiosk'
      produces 'application/json'
      parameter name: :auth, in: :header, type: :string, required: true
      parameter name: :device_id, in: :header, type: :string, required: true
        
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

  path '/api/kiosk/reset_pin' do

    post 'Reset pin of visitor' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
         properties: {
          registrant:{ type: :object,
            properties: {
              phone_mobile: { type: :string },
              vendor_pin_c: {type: :integer}
            }
          },
          type: {type: :string}

        },
        required: [ 'phone_mobile', 'vendor_pin_c', 'type' ]
        }

        response '200', 'Success' do
          let(:json) { {visitor: {first_name:'', last_name:'', phone_num:''}, type:"Visitor/Vendor"} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Missing Phone number' }
          run_test!
        end
    end
  end

  path '/api/kiosk/sign_in' do

    post 'Visitor Login' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
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

end
