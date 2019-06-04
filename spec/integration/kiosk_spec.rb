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
                status_c: {type: :string},
                avatar_url: {type: :string}
                
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
        parameter name: :type, in: :query, type: :string, required: true
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
      parameter name: :vendor_id, in: :query, type: :string, required: true
      parameter name: :type, in: :query, type: :string, required: true
        
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
          vendor_id: { type: :integer },
          agreement_ids: { type: :object }
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

  path '/api/kiosk/process_events' do

    post 'Visitor signin request' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
         properties: {
          entries:{ type: :object,
            properties: {
              visitor_type: { type: :string },
              visit_entry_type: { type: :string },
              visitor_id: { type: :integer },
              event_time: { type: :string },
              department_id: { type: :integer },
              person_name: { type: :string },
              event_id: { type: :string }
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

  path '/api/kiosk/forgot_pin' do

    post 'Validate Phone number' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
        parameter name: :type, in: :query, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          phone_mobile: { type: :string }
        },
        required: [ 'phone_mobile' ]
        }

        response '200', 'Verification code sent' do
          let(:json) { {otp:otp, message:"Verification code sent"} }
          run_test!
        end

        response '404', 'Invalid Request' do
           let(:json) { 'Invalid Phone number' }
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
        parameter name: :type, in: :query, type: :string, required: true
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

  path '/api/kiosk/qr_signin' do

    get 'Sign in using QR Code' do
      tags 'Kiosk'
      produces 'application/json'
      parameter name: :auth, in: :header, type: :string, required: true
      parameter name: :device_id, in: :header, type: :string, required: true
      parameter name: :qrcode, in: :query, type: :string, required: true
      parameter name: :type, in: :query, type: :string, required: true
      response '200', 'Success' do
           schema type: :array,
          properties: {
            visit:{ type: :object,
              properties: {
                  id: { type: :integer },
                  visitor_type: {type: :string},
                  visitor_id: { type: :integer },
                  company_id: {type: :integer},
                  department_id: { type: :integer },
                  department_name: { type: :string },
                  visit_status: { type: :string },
                  person_name: { type: :string },
                  event_id: { type: :string },
                  qrcode: { type: :string },
                  tentative_datetime: { type: :string },
                  event_date_time: { type: :string },
                  date_entered: { type: :string },
                  date_modified: { type: :string }
              }
            },
            status: {type: :integer}
          }

        let(:'auth') { '<token-here>' }
        run_test!
      end

      response '400', 'Invalid QR Code' do
        let(:'auth') { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/kiosk/process_qr_events' do

    post 'QR Visitor signin request' do
        tags 'Kiosk'
        consumes 'application/json'
        parameter name: :auth, in: :header, type: :string, required: true
        parameter name: :device_id, in: :header, type: :string, required: true
        parameter name: :input, in: :body, schema: {
        type: :object,
         properties: {
          entries:{ type: :object,
            properties: {
              visit_id: { type: :integer },
              event_time: { type: :string },
              event_id: { type: :string }
            }
          }
        },
        required: [ 'visit_id', 'event_time', 'event_id' ]
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

  path '/api/kiosk/signout' do

    get 'Signout using QR Code' do
      tags 'Kiosk'
      produces 'application/json'
      parameter name: :auth, in: :header, type: :string, required: true
      parameter name: :device_id, in: :header, type: :string, required: true
      parameter name: :qrcode, in: :query, type: :string, required: true
      parameter name: :event_time, in: :query, type: :string, required: true
      response '200', 'Success' do
           schema type: :array,
          properties: {
            visit:{ type: :object,
              properties: {
                  id: { type: :integer },
                  visitor_type: {type: :string},
                  visitor_id: { type: :integer },
                  department_id: { type: :integer },
                  department_name: { type: :string },
                  visit_status: { type: :string },
                  person_name: { type: :string },
                  event_id: { type: :string },
                  qrcode: { type: :string },
                  tentative_datetime: { type: :string },
                  event_date_time: { type: :string },
                  date_entered: { type: :string },
                  date_modified: { type: :string }
              }
            },
            status: {type: :integer}
          }

        let(:'auth') { '<token-here>' }
        run_test!
      end

      response '400', 'Invalid QR Code' do
        let(:'auth') { 'invalid' }
        run_test!
      end
    end
  end
  

end
