class PayrollAccountsParentRecordsController < ApplicationController
  before_action :set_parent_record, only: [:show, :edit, :update, :destroy]

  # GET /payroll_accounts_parent_records
  def index
    @parent_records = PayrollAccountsParentRecord.all
  end

  # GET /payroll_accounts_parent_records/1
  def show
  end

  # GET /payroll_accounts_parent_records/new
  def new
    @parent_record = PayrollAccountsParentRecord.new
    @parent_record.payroll_accounts_foapal_entries.build
    @parent_record.eclass = 'P2'
  end

  # GET /payroll_accounts_parent_records/1/edit
  def edit
  end

  # POST /payroll_accounts_parent_records
  def create
    @parent_record = PayrollAccountsParentRecord.new(parent_record_params)
    if @parent_record.save
      redirect_to @parent_record, notice: 'Parent record was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /payroll_accounts_parent_records/1
  def update
    if @parent_record.update(parent_record_params)
      redirect_to @parent_record, notice: 'Parent record was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /payroll_accounts_parent_records/1
  def destroy
    @parent_record.destroy
    redirect_to payroll_accounts_parent_records_url, notice: 'Parent record was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parent_record
      @parent_record = PayrollAccountsParentRecord.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def parent_record_params
      params.require(:payroll_accounts_parent_record).permit(:name, :orgn, :orgn_description, :eclass, :payroll_accounts_foapal_entries_attributes => foapal_entries_attributes)
    end

    def foapal_entries_attributes
      [
        :id,
        :fund,
        :fund_description,
        :orgn,
        :orgn_description,
        :acct,
        :acct_description,
        :prog,
        :prog_description,
        :actv,
        :actv_description,
        :locn,
        :locn_description,
        :foapal_percent,
        :foapal_percent_string,
        :payroll_accounts_parent_record_id,
        :acct_type,
        :fund_type,
        :predecessor_acct_type,
        :predecessor_fund_type,
        :acct_class,
        :_destroy]
    end

end
