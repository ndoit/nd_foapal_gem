class LimitedOrgTestsController < ApplicationController

  # GET /limited_org_tests/:number_of_orgns
  def new
    @limited_org_test = LimitedOrgTest.new
    case params[:number_of_orgns]
    when 'one_orgn'
      @orgnData = [{value: '29015', label: '29015 - Customer IT Services'}].to_json
    when 'three_orgn'
      @orgnData = [{value: '29015', label: '29015 - Customer IT Services'},
            {value: '34000', label: '34000 - MCOB Dean Office'},
            {value: '34005', label: '34005 - Dept of Accountancy'}].to_json
    else
      @orgnData = [].to_json
    end
  end

end
