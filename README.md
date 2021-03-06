# NdFoapalGem #

This Rails plug in provides FOAPAL related functionality.  Functionality included:
- autocomplete for Fund, Org, Account, Program, Activity and Location
- Account autocomplete for all accounts or Payroll accounts specified by eclass
- Org autocomplete for all orgs or orgs filtered by fund
- Program autocomplete restricted by fund and org
- Setting Account, Org and Prog input field values to a single value as appropriate
- determination of whether or not a fund is a grant or cost share account
- return of RSPA accountant for a specific grant or cost share account

### Installation ###

Add the following to your Gemfile (or similar if the foapal version has changed), then run ```bundle install```
```
gem 'dotenv' # if does not already exist
gem 'cocoon' # if does not already exist
gem 'nd_foapal_gem', '~> 0.1.0', git: 'git@bitbucket.org:nd-oit/nd_foapal_gem.git'
```

Add following to application.js
```
//= require jquery
//= require jquery_ujs
//= require cocoon
//= require nd_foapal_gem/nd_foapal
```

Setup .env.local
```
You will need to have FINANCE_API_BASE and FINANCE_API_KEY defined
```

### How To ###

The javascript function nd_foapal_initialize() must be run on document ready.

### Include a field that allows all Orgs and will set an Org Description field ###
Add two input fields to the form.  One will have a class of orgn_full_input, the other
will have a class of orgn_description_input.  The id for the orgn must be in the format:
<custom text>_<number>_orgn.  The id for the description must be in the format:
<same custom text>_<same number>_orgn_description.

The javascript function nd_foapal_initialize() must be run on document ready.

Example: spec/dummy/app/views/parent_records/_form.html.erb

### Include a set of FOAPAL fields where the selected fund limits the available orgs and the fund/orgn limit the available progs ###
Your model should at a minimum have the attributes fund, fund_description, orgn, orgn_description, acct, acct_description, prog, prog_description,
and most will also include actv, actv_description and locn, locn_description.  Additional attributes can be set for fund and acct.

Note that the different input fields for the different foapal elements must have specific class names.  See the example views for details.

The javascript relies on behavior of the cocoon gem.  A set of FOAPAL fields must be contained within a tag with an id foapal_table and then
within that tag another tag with a class of foapal_table_data_row.  If multiple FOAPALs rows can be added, the add FOAPAL button must have an
id of b_foapal_insert.

Example:
Migration: spec\dummy\db\migrate\20180104192926_create_foapal_entries.rb
Model: spec\dummy\app\models\foapal_entry.rb
View: spec\dummy\app\views\parent_records\_foapals_acct_full_table.html.erb & _foapal_entry_fields_acct_full.html.erb

### Restricting account codes to a specific list ###
Some projects will require that account codes are limited to a specific list.  For example Labor Distribution Changes and New Job Actions.
To accomplish this functionality, the account input fields in the FOAPAL rows must have a class of acct_data_input and a global javascript variable
acctData must be populated with an array of hashes.

A method for generating the appropriate acctData json result for Payroll accounts based on
eclass is included in the NdFoapalGem::FoapalData.  A new instance (fd) of NdFoapalGem::FoapalData should be created with data_type: epac and
search_string equal to the appropriate eclass.  Then acctData can be retrieved by calling fd.searchAcctDataString.

For Payroll accounts, the acctData variable can be reset via Javascript using the function setupAcctDataAutocompleteBasedOnEclass(<eclass>);
See spec\dummy\app\views\payroll_accounts_parent_records\_form.html.erb

Example:
Controller: spec\dummy\app\controllers\payroll_accounts_parent_records_controller.rb  see method new where eclass is set.
Model: spec\dummy\app\models\payroll_accounts_parent_record.rb  see method acctDataForJavascript
View: spec\dummy\app\views\payroll_accounts_parent_records\_form.html.erb   see where var acctData is being set.

### Restricting orgn codes to a specific list ###
Some projects will require that orgn codes are limited to a specific list.  
To accomplish this functionality, an orgn input field can have a class of orgn_data_input and a global javascript variable
orgnData must be populated with an array of hashes.

Example:
Controller: spec\dummy\app\controllers\limited_org_tests_controller.rb  see method new.
View: spec\dummy\app\views\limited_org_tests\_form.html.erb   see where var orgnData is being set and orgn_data_input fields and corresponding orgn_data_description_input fields are available..


### Determining Grant/Cost Share Funds and retrieving RSPA accountant information ###
The model NdFoapalGem::Fund can be used to determine if a fund is a grant or cost share fund and then to retrieve the responsible RSPA
accountant.  Initialize an instance of Fund (f) via NdFoapalGem::Fund(fund).  You can immediately determine if the fund is a grant or cost share
account via the Fund method is_grant_or_cost_share_fund?  For the RSPA accountant first call f.set_fund_attributes.  The rspa data is available
as f attributes rspa_accountant_net_id, rspa_accountant_first_name, rspa_accountant_last_name.

Example: spec\dummy\app\helpers\rspa_helper.rb

### Input class: add_foapal_row_on_return ###
You can add the class add_foapal_row_on_return to the right most input field in your foapal row (usually an amount or percent field) to have
a new blank foapal row added when the user clicks return in the field.  See spec/dummy/app/views/parent_records/_foapal_entries_acct_full_table.html.erb
for an example.  Requires that your link_to_add_association has an id of b_foapal_insert.


### View Examples ###
```
See spec/dummy/app/views/parent_records/_foapal_entries_show.html.erb for an example for displaying _foapal_entries_show
See spec/dummy/app/views/parent_records/_foapal_entries_acct_full.html.erb for an example of foapal entries where account can be any active account
See spec/dummy/app/views/parent_records/_foapal_entries_acct.html.erb for an example of foapal entries where account is limited (i.e. Payroll accounts for a certain eclass)
```

### Javascript: onReadySetFoapalTitlesOnly() ###
Use on your show page on ready to make sure all foapal elements have title attributes for all foapal elements.  Only needed if you find that the
FOAPAL description is not getting set in the new/edit form.

### Javascript: onReadySetFoapalTitlesDescriptions() ###
Use on your new/edit form page to make sure all foapal elements have description fields populated.  Only needed if you find that the
FOAPAL description is not getting set in the new/edit form.

### Javascript: validate_foapal( fund, orgn, acct, prog, actv, locn) ###
Checks the validity of the foapal provided. If the foapal is valid returns an empty string, else it returns a string with a description of the validation error.

### Model: NdFoapalGem::FoapalData ###
Can be used to search for and validate foapal data.
attr_accessor :data_type, :search_string, :type, :fund, :orgn, :acct, :prog, :actv, :locn

Usage:
f = NdFoapalGem::FoapalData.new( data_type: 'fund', search_string: '201')
search_results = f.search
** search_results contains all funds that begin with 201.  This same approach can be used for orgn, acct, prog, actv and locn.

f = NdFoapalGem::FoapalData.new( data_type: 'validate', fund: '100000', orgn: '34000', acct: '72001', prog: '10000')
f.valid? # validates that the passed values are valid for FOAP data and validation
search_results = f.search
** search_results contains the string returned from the ND Foapal validator

### Helper: NdFoapalGem::FoapalHelper ###
Has some very helpful methods.

Usage:
include NdFoapalGem::FoapalHelper
 
fop_lookup(foapal_part, part_value) - returns the matching data
set_description(foapal_part) - sets the corresponding description attribute for a given foapal_part

more...


### Who do I talk to? ###

* Teresa Meyer (tmeyer2@nd.edu)
* Employee Finance Solutions
