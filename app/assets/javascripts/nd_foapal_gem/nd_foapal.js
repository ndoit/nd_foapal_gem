function nd_foapal_initialize() {
    setupFoapalAutocomplete();
    setOrgnFullAutocomplete();
    setOrgnDataAutocomplete();
    loadInitialFoapalAutocomplete();
    $('#foapal_table').on('cocoon:after-insert', function(e, insertedRow) {
      setupFoapalAutocomplete();
      $(insertedRow).find('.fund_input').focus();
    });
}

function onReadySetFoapalTitlesOnly() {
  var foap_parts = ["fund","orgn_data","orgn_full","acct_data","acct_full","prog","actv","prog"];
  for (j = 0; j < foap_parts.length; j++) {
    $('.' + foap_parts[j] + '_span').mouseenter( function() {
      if (this.title == "") {
        this.title = "Setting title...";
        setTitle(this);
      }
    });
  }
}

function onReadySetFoapalTitlesDescriptions() {
  var foap_parts = ["fund","orgn_data","orgn_full","acct_data","acct_full","prog","actv","prog"];
  for (j = 0; j < foap_parts.length; j++) {
    $('.' + foap_parts[j] + '_input').mouseenter( function() {
      if (this.title == "" && this.value.length > 4) {
        this.title = "Setting title...";
        setDescription(this);
      }
    });
  }

}

function setupFoapalAutocomplete( ) {
  setFundDataAutocomplete();
  setInitialAcctDataAutocomplete();
  setAcctDataFullAutocomplete();
  setActvDataAutocomplete();
  setLocnDataAutocomplete();
  $('.add_foapal_row_on_return').keypress( function( event) { addFoapalRowOnReturn( event, this); });
}

/**********************************************/
function addFoapalRowOnReturn( e, field) {

  var key=e.keyCode || e.which;
  if (key == 13) {
    var foapal_row = $(field).closest('.foapal_table_data_row');
    var foapal_body = foapal_row[0].parentNode;
    var foapal_rows = $(foapal_body).children().filter(':visible');
    var field_row = $(field).closest('.nested-fields');
    var foapal_visible_rows = $(foapal_body).find('.nested-fields').filter(':visible');
    var row = $(foapal_visible_rows).index(field_row);
    if (foapal_visible_rows.length - 1 == row)
      $('#b_foapal_insert').click();
    else {
      var fund_input_field = $(foapal_visible_rows[row+1]).find('.fund_input');
      if (fund_input_field.length > 0)
        $(foapal_visible_rows[row+1]).find('.fund_input').focus();
      else
        $(foapal_visible_rows[row+1]).find('.debit_amount_input').focus();
    }
  }
}

function setTitle(span_field) {
  var classes = span_field.className.split(/\s/);
  for (i=0;i<classes.length;i++) {
    if (classes[i].match(/_span/g)) {
      var field_type = classes[i].substr(0,4);
    }
  }
  setFoapalPartTitleOnly(span_field,field_type,span_field.textContent);
}

function setFoapalPartTitleOnly(span_field,data_type,search_value) {

  var lookup_url = "/nd_foapal_gem/fop_data/" + data_type + "/" + search_value;
  if (search_value == 'Error' || search_value == 'No match') return;
  $.ajax({
        url: lookup_url,
        dataType: "json",
        data: {
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
              do_alert("FOAP[AL] description lookup error for " + data_type + ". Please confirm that the financial data web services are running. (" + textStatus + " | " + errorThrown + ")");
        },
        success: function (data) {
          switch(data_type) {
            case "fund": span_field.title = data[0].fund + " - " + data[0].fund_title;
                        break;
            case "orgn": span_field.title = data[0].orgn + " - " + data[0].orgn_title;
                        break;
            case "acct": span_field.title = data[0].acct + " - " + data[0].acct_title;
                        break;
            case "prog": span_field.title = data[0].prog + " - " + data[0].prog_title;
                        break;
            case "actv": span_field.title = data[0].actv + " - " + data[0].actv_title;
                        break;
            case "locn": span_field.title = data[0].locn + " - " + data[0].locn_title;
                        break;
          }
        }
    });

}

function setDescription(input_field) {
  var classes = input_field.className.split(/\s/);
  for (i=0;i<classes.length;i++) {
    if (classes[i].match(/_input/g)) {
      var field_type = classes[i].substr(0,4);
    }
  }
  setFoapalPartTitle(input_field,field_type,input_field.value);
}

function setFundTitleDescriptionType(input_field,banner_data) {
  input_field.title = banner_data.fund + " - " + banner_data.fund_title;
  var fund_desc_field = "#" + getNewInputFieldName( input_field, "fund_description");
  $(fund_desc_field).val(banner_data.fund_title);
  var fund_type_field = "#" + getNewInputFieldName( input_field, "fund_type");
  var predecessor_fund_type_field = "#" + getNewInputFieldName( input_field, "predecessor_fund_type");
  if ($(fund_type_field).length > 0) {
    $(fund_type_field).val(banner_data.fund_type);
    $(predecessor_fund_type_field).val(banner_data.predecessor_fund_type);
  }
}

function setOrgnTitleDescription(input_field,banner_data) {
  input_field.title = banner_data.orgn + " - " + banner_data.orgn_title;
  var org_desc_field = "#" + getNewInputFieldName( input_field, "orgn_description");
  $(org_desc_field).val(banner_data.orgn_title);
}

function setAcctTitleDescriptionType(input_field, banner_data) {
  input_field.title = banner_data.acct + " - " + banner_data.acct_title;
  var acct_desc_field = "#" + getNewInputFieldName( input_field, "acct_description");
  $(acct_desc_field).val(banner_data.acct_title);
  var acct_type_field = "#" + getNewInputFieldName( input_field, "acct_type");
  var predecessor_acct_type_field = "#" + getNewInputFieldName( input_field, "predecessor_acct_type");
  var acct_class_field = "#" + getNewInputFieldName( input_field, "acct_class");
  if ($(acct_type_field).length > 0) {
      $(predecessor_acct_type_field).val(banner_data.predecessor_acct_type);
      $(acct_type_field).val(banner_data.acct_type);
      $(acct_class_field).val(banner_data.acct_class);
    }
}

function setProgTitle(input_field,banner_data) {
  input_field.title = banner_data.prog + " - " + banner_data.prog_title;
  var prog_desc_field = "#" + getNewInputFieldName( input_field, "prog_description");
  $(prog_desc_field).val(banner_data.prog_title);
}

function setActvTitle(input_field,banner_data){
  input_field.title = banner_data.actv + " - " + banner_data.actv_title;
  var actv_desc_field = "#" + getNewInputFieldName( input_field, "actv_description");
  $(actv_desc_field).val(banner_data.actv_title);
}

function setLocnTitle(input_field,banner_data) {
  input_field.title = banner_data.locn + " - " + banner_data.locn_title;
  var locn_desc_field = "#" + getNewInputFieldName( input_field, "locn_description");
  $(locn_desc_field).val(banner_data.locn_title);
}

function setFoapalPartTitle(input_field,data_type,search_value) {
  var data_type_base = data_type.substring(0,4);
  var lookup_url = "/nd_foapal_gem/fop_data/" + data_type_base + "/" + search_value;
  if (search_value == 'Error' || search_value == 'No match') return;
  $.ajax({
        url: lookup_url,
        dataType: "json",
        data: {},
        error: function(XMLHttpRequest, textStatus, errorThrown) {
              do_alert("FOAP[AL] description lookup error for " + data_type_base + ". Please confirm that the financial data web services are running. (" + textStatus + " | " + errorThrown + ")");
        },
        success: function (data) {
          $(input_field).removeClass('ui-autocomplete-loading');
          if (data.length == 1) {
          switch(data_type_base) {
            case "fund":
                setFundTitleDescriptionType(input_field,data[0]);
                break;
            case "orgn":
                setOrgnTitleDescription(input_field,data[0]);
                break;
            case "acct":
                setAcctTitleDescriptionType(input_field, data[0]);
                break;
            case "prog":
                setProgTitle(input_field, data[0]);
                break;
            case "actv":
                setActvTitle(input_field, data[0]);
                break;
            case "locn":
                setLocnTitle(input_field, data[0]);
                break;
          }
          }
        }
    });

}

function setFoapalPartsTitles(row_number,foap_parts) {
  var foapal_fields = ["fund","orgn_data","orgn_full","acct_data","acct_full", "prog","actv","locn"];
  var foapal_fields_index = 0;
  for (j = 0; j < foap_parts.length; j++)  {
    var row_string = '.foapal_table_data_row:nth-child(' + row_number + ')';
    var input_field_string = '.' + foapal_fields[foapal_fields_index] + '_input:first';
    var input_fld = $(row_string + ' ' + input_field_string );
    if (input_fld.length == 0) {
      foapal_fields_index++;
      var input_field_string = '.' + foapal_fields[foapal_fields_index] + '_input:first';
      input_fld = $(row_string + ' ' + input_field_string );
    }
    setFoapalPartTitle(input_fld, foapal_fields[foapal_fields_index], foap_parts(j));
    foapal_fields_index++;
  }
}

function setupAcctDataAutocompleteBasedOnEclass( eclass) {
  if (typeof acctData == 'undefined') {
    return;
  }

   acctData = [];
   var lookup_url = "/nd_foapal_gem/fop_data/epac/" + eclass;
  $('#find_acct_data').addClass("ajax-processing");

  $.ajax({ url: lookup_url,
    contentType: "json",
    dataType: "json",
    type: "GET",
    error: function(XMLHttpRequest, textStatus, errorThrown) {
        $('#find_acct_data').removeClass("ajax-processing");
        do_alert("An error has occurred while attempting to retrieve FOAPAL account data.  Please confirm that all necessary web services are running. (Set up account list: " + errorThrown + ")");
      },
    success: function (data, status, xhr) {
        $('#find_acct_data').removeClass("ajax-processing");
      if (data.length == 0 || (data.length == 1 && typeof data[0].epac !== "undefined" && data[0].epac.toUpperCase() == "ERROR")) {
        $('#acct_not_found').show();
      }
      else {
        $('#acct_not_found').hide();
        for (i = 0; i < data.length; i++ ) {
            acctData.push({value: data[i].acct, label: data[i].acct + " - " + data[i].acct_title});
        }
        setInitialAcctDataAutocomplete();
      }
    }
  });
}
/*******************************************/
function setAcctDataAutocomplete( data_type, p_data) {

  if (typeof acctData === "undefined") {
    return;
  }


  if (data_type == "sib") {
    var acct_target = "#" + getNewInputFieldName( p_data,"acct");
    var acct_description = "#" + getNewInputFieldName( p_data,"acct_description");
  }
  else {
    var foapal_row_n = Number(p_data);
    var foapal_row_object = $('#foapal_table .foapal_table_data_row').eq(foapal_row_n);
    var a_target_fld = $(foapal_row_object[0]).find('input.acct_full_input');
    if (a_target_fld.length == 0) {
      var a_target_fld = $(foapal_row_object[0]).find('input.acct_data_input');
    }
    var acct_target = '#' + a_target_fld[0].id;
    var acct_description = '#' + $(foapal_row_object[0]).find('input.acct_description_input')[0].id;
  }
  if ($(acct_target).hasClass('ui-autocomplete-input')) {
    $(acct_target).autocomplete("destroy");
    $(acct_target).removeClass('ui-autocomplete-input');
  }
  $(acct_target)
     .prop('readOnly', false);

  if ( acctData.length == 0) {
    $(acct_target).removeClass('ui-autocomplete-loading');
    return;
  }

  if (data_type == "sib") {
    $(acct_target).val("");
    $(acct_target).prop('title',"");
    $(acct_description).val("");
  }

  if (acctData.length == 1) {
    $(acct_target).val( acctData[0].value);

    $(acct_target).prop('title',acctData[0].label);
    $(acct_target).prop('readOnly',true);
    var tstr = acctData[0].label.split(" ");
    tstr.shift();
    tstr.shift();
    $(acct_description).val(tstr.join(" "));
  }
  else {
    $(acct_target).autocomplete({
            source: acctData,
            select: function (event, ui) {
              setFoapalPartTitle(this, "acct", ui.item.value);
            },
            minLength: 0
    })
    .focus( function() {
      $(this).autocomplete( "search");
    });
    $('.ui-autocomplete').addClass('f-dropdown');
    $(acct_target).prop('readOnly',false);
  }
}

/*******************************************/
function setOrgnDataAutocomplete() {

  if (typeof orgnData === "undefined") {
    return;
  }

  $('.orgn_data_input').prop('readOnly', false);

  var orgn_data_input_fields = document.getElementsByClassName("orgn_data_input");

  for (i=0;i<orgn_data_input_fields.length;i++) {
    if ($(orgn_data_input_fields[i]).hasClass('ui-autocomplete-input')) {
      $(orgn_data_input_fields[i]).autocomplete("destroy");
      $(orgn_data_input_fields[i]).removeClass('ui-autocomplete-input');
    }
    if ( orgnData.length == 0) {
      $(orgn_data_input_fields[i]).removeClass('ui-autocomplete-loading');
    }

  }

  if ( orgnData.length == 0) {
    return;
  }

  if (orgnData.length == 1) {
    $('.orgn_data_input').val( orgnData[0].value);
    $('.orgn_data_input').prop('title',orgnData[0].label);
    $('.orgn_data_input').prop('readOnly',true);
    var tstr = orgnData[0].label.split(" ");
    tstr.shift();
    tstr.shift();
    $('.orgn_data_description_input').val(tstr.join(" "));
    return;
  }

  $('.orgn_data_input').autocomplete({
          source: orgnData,
          select: function (event, ui) {
            setFoapalPartTitle(this, "orgn", ui.item.value);
          },
          minLength: 0
  })
  .focus( function() {
    $(this).autocomplete( "search");
  });
  $('.ui-autocomplete').addClass('f-dropdown');
  $('.orgn_data_input').prop('readOnly',false);
}

function setFundDataAutocomplete() {
  var lookup_url = "/nd_foapal_gem/fop_data/fund/";

  $(".fund_input").autocomplete({
    source: function( request, response) {


      $.ajax({
        url: "/nd_foapal_gem/fop_data/fund/" + request.term,
        dataType: "json",
        delay: 1000,
        data: {

        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
              do_alert("Lookup error for funds. If your fund values are valid, please confirm that the financial data web services are running. (" + errorThrown + ")");
        },
        success: function (data) {
          response( $.map(data, function( item) {
            return {
              label: item.fund + " - " + item.fund_title,
              value: item.fund
            }
          }));
        }
      });
    },
    minLength: 1,
    select: function (event, ui) {
//      setFoapalPartTitle(this, "fund", ui.item.value);
//      setOrgnData( "sib", this, ui.item.value);
//      setAcctDataAutocomplete( "sib", this);
      clearOrgnData(this);
      clearProgData(this);
    },
    change: function( event) {
        setFoapalPartTitle(this,"fund",event.currentTarget.value)
        setOrgnData( "sib", this, event.currentTarget.value);
        setAcctDataAutocomplete( "sib", this);
        $( this ).removeClass( "ui-autocomplete-loading" )
    },
      open: function() {
        $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
      },
      close: function() {
        $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
      }

  });

}

function setAcctDataFullAutocomplete() {
  setFullAcctActvLocnAutocomplete('acct');
}
function setActvDataAutocomplete() {
  setFullAcctActvLocnAutocomplete('actv');
}
function setLocnDataAutocomplete() {
  setFullAcctActvLocnAutocomplete('locn');
}

function setFullAcctActvLocnAutocomplete(data_type) {
  var lookup_url = "/nd_foapal_gem/fop_data/" + data_type + "/";
  var input_class = data_type;
  $('#nd_foapal_gem_foapal_element').val(data_type);
  switch (data_type) {
  case 'acct':
    var input_class = 'acct_full';
    var data_type_label = 'accounts';
    break;
  case 'actv':
    var data_type_label = 'activities';
    break;
  case 'locn':
    var data_type_label = 'locations';
    break;
  }

  $("." + input_class + "_input").autocomplete({
    source: function( request, response) {

      $.ajax({
        url: "/nd_foapal_gem/fop_data/" + data_type + "/" + request.term,
        dataType: "json",
        delay: 1000,
        data: {},
        error: function(XMLHttpRequest, textStatus, errorThrown) {
              do_alert("Lookup error for " + data_type + ". If your " + data_type_label + " values are valid, please confirm that the financial data web services are running. (" + errorThrown + ")");
        },
        success: function (data) {
          response( $.map(data, function( item) {
            switch (data_type) {
            case 'acct':
              var dt_label = item.acct + " - " + item.acct_title;
              var dt_value = item.acct;
              break;
            case 'actv':
              var dt_label = item.actv + " - " + item.actv_title;
              var dt_value = item.actv;
              break;
            case 'locn':
              var dt_label = item.locn + " - " + item.locn_title;
              var dt_value = item.locn;
              break;
            }

            return { label: dt_label, value: dt_value }
          }));
        }
      });
    },
    minLength: 1,
    select: function (event, ui) {
      setFoapalPartTitle(this, data_type, ui.item.value);
    },
    change: function(event) {
      setFoapalPartTitle(this,data_type,event.currentTarget.value);
    }
  })
  .focus( function() {
    $(this).autocomplete( "search");
  });

}

function setOrgnFullAutocomplete() {
  var lookup_url = "/nd_foapal_gem/fop_data/orgn/";

  $(".orgn_full_input").autocomplete({
    source: function( request, response) {
      $.ajax({
        url: "/nd_foapal_gem/fop_data/orgn/" + request.term,
        dataType: "json", delay: 1000, data: { },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
              do_alert("Lookup error for organizations. If your organization value is valid, please confirm that the financial data web services are running. (" + errorThrown + ")");
        },
        success: function (data) {
          response( $.map(data, function( item) {
            return {
              label: item.orgn + " - " + item.orgn_title,
              value: item.orgn
            }
          }));
        }
      });
    },
    minLength: 1,
    delay: 500,
    select: function (event, ui) {
      var label = ui.item.label.split(' - ');
      var banner_data = new Object;
      banner_data.orgn = label[0];
      banner_data.orgn_title = label[1];
      setOrgnTitleDescription(this,banner_data)
    },
    change: function ( event) {
      setFoapalPartTitle(this,"orgn",event.currentTarget.value);
      $( this ).removeClass( "ui-autocomplete-loading" )
    }
  })
  .focus( function() {
    var org_value = $(this).val();
    if (org_value.length > 0) $(this).autocomplete( "search");
  });
}

function setDescriptionField ( foapal_element, code_field, list_label) {
  var tstr = list_label.split(" ");
  tstr.shift();
  tstr.shift();
  var description = tstr.join(" ");
  var desc_field = "#" + getNewInputFieldName( code_field, foapal_element + "_description");
  $(desc_field).val(description);
}

function clearOrgnData (  p_data) {
  var org_field = "#" + getNewInputFieldName( p_data, "orgn");
  var org_desc_field = "#" + getNewInputFieldName( p_data, "orgn_description");
  if ($(org_field).hasClass('ui-autocomplete-input')) {
    $(org_field).autocomplete("destroy");
    $(org_field).removeClass('ui-autocomplete-input');
  }
  $(org_field)
    .prop('readOnly', false)
    .val('');
  $(org_desc_field).val('');
}

function setOrgnData ( data_type, p_data, fund_value) {

  if (data_type == "sib") {
    var org_field = "#" + getNewInputFieldName( p_data, "orgn");
    var org_desc_field = "#" + getNewInputFieldName( p_data, "orgn_description");
  }
  else {
    var foapal_row_n = Number(p_data);
    var foapal_row_object = $('#foapal_table .foapal_table_data_row').eq(foapal_row_n);
    var org_field_obj = $(foapal_row_object).find('.orgn_input');
    var org_desc_field_obj = $(foapal_row_object).find('.orgn_description_input');
    var org_field = '#' + org_field_obj[0].id;
    var org_desc_field = '#' + org_desc_field_obj[0].id;
  }


  if (data_type == "sib") {
    $( org_field).val("");
    $(org_field).prop('title','');
    $(org_desc_field).val("");
  }

  var orgList;

  if ($(org_field).hasClass('ui-autocomplete-input')) {
    $(org_field).autocomplete("destroy");
    $(org_field).removeClass('ui-autocomplete-input');
  }
  $(org_field)
     .prop('readOnly', false)
     .addClass('ui-autocomplete-loading');
  var lookup_url = "/nd_foapal_gem/fop_data/orgn/f/" + fund_value;
  $.ajax({
        url: lookup_url,
        dataType: "json",
        delay: 1000,
        error: function(XMLHttpRequest, textStatus, errorThrown) {
              do_alert("Lookup error for organizations. If your fund and organization values are valid, please confirm that the financial data web services are running. (" + errorThrown + ")");
        },
        success: function (data) {

          if (data.length == 1) {
            if ( data[0].orgn != "None" && data[0].orgn != "Error") {
               $(org_field).val(data[0].orgn);
               $(org_field).prop('title',data[0].orgn + " - " + data[0].orgn_title);
               $(org_desc_field).val(data[0].orgn_title);
               setProgData( data_type, p_data, data[0].orgn);
            }
            else {
               if ( data[0].orgn == "None") {
                 $(org_field).val("No match");
                 $(org_field).prop('No Organizations found for fund '+fund_value);
                 $(org_desc_field).val("Invalid Organization.");

               }
               else {
                 $(org_field).val("Error");
                 $(org_field).prop('An error occurred with the Financial Web Service. ');
                 $(org_desc_field).val("An error occurred with the Financial Web Service. ");

               }
            }
            $(org_field).prop('readOnly', true);
          }
          else {
              $(org_field).autocomplete({
                  source: function (request, response) {
                    var lookup_url = "/nd_foapal_gem/fop_data/orgn/f/" + fund_value;
                    if (request.term != "")
                      lookup_url += "/" + request.term;

                    $.ajax({
                      url: lookup_url, dataType: "json", delay: 1000,
                      error: function(XMLHttpRequest, textStatus, errorThrown) {
                          do_alert("Lookup error for organizations. If your fund and organization values are valid, please confirm that the financial data web services are running. (" + errorThrown + ")");
                      },
                      success: function (data) {
                        response( $.map(data, function( item) {
                          return {
                            label: item.orgn + " - " + item.orgn_title,
                            value: item.orgn
                          }
                        }));
                      }
                    });
                  },
                  minLength: 1,
//                  select: function (event, ui) {
//                    this.title = ui.item.label;
//                    var tstr = ui.item.label.split(" ");
//                    tstr.shift();
//                    tstr.shift();

//                    $(org_desc_field).val(tstr.join(" "));
//                    setProgData( "sib", this, ui.item.value);
//                  },
                  select: function ( event) {
                    clearProgData(this);
                  },
                  change: function ( event) {
                    setFoapalPartTitle(this,"orgn",event.currentTarget.value)
                    setProgData( "sib", this, event.currentTarget.value);
                    $( this ).removeClass( "ui-autocomplete-loading" )
                  }
                });
              //  .focus( function() { $(this).autocomplete( "search"); });
          }
          $(org_field).removeClass('ui-autocomplete-loading');
        }
  });


}


function clearProgData (  p_data) {
  var prog_field = "#" + getNewInputFieldName( p_data, "prog");
  var prog_desc_field = "#" + getNewInputFieldName( p_data, "prog_description");
  if ($(prog_field).hasClass('ui-autocomplete-input')) {
    $(prog_field).autocomplete("destroy");
    $(prog_field).removeClass('ui-autocomplete-input');
  }
  $(prog_field)
    .prop('readOnly', false)
    .val('');
  $(prog_desc_field).val('');

}

function setProgData ( data_type, p_data, orgn_value) {

  if (data_type == "sib") {
    var prog_field = "#" + getNewInputFieldName( p_data, "prog");
    var fund_field = "#" + getNewInputFieldName( p_data, "fund");
    var prog_desc_field = "#" + getNewInputFieldName( p_data, "prog_description");

  }
  else {
    var foapal_row_n = Number(p_data);
    var foapal_row_object = $('#foapal_table .foapal_table_data_row').eq(foapal_row_n);
    var prog_field_obj = $(foapal_row_object).find('.prog_input');
    var prog_desc_field_obj = $(foapal_row_object).find('.prog_description_input');
    var fund_field_obj = $(foapal_row_object).find('.fund_input');
    var prog_field = '#' + prog_field_obj[0].id;
    var prog_desc_field = '#' + prog_desc_field_obj[0].id;
    var fund_field = '#' + fund_field_obj[0].id;
  }

  if (data_type == "sib") {
    $(prog_field).val("");
    $(prog_field).prop('title','');
    $(prog_desc_field).val("");
  }

  var fund_value = $(fund_field).val();

  if (fund_value == "") return;

  if ($(prog_field).hasClass('ui-autocomplete-input')) {
    $(prog_field).autocomplete("destroy");
    $(prog_field).removeClass('ui-autocomplete-input');
  }
  $(prog_field)
     .prop('readOnly', false)
     .addClass('ui-autocomplete-loading');
  var lookup_url = "/nd_foapal_gem/fop_data/prog/f/" + fund_value + "/o/" + orgn_value;
  $.ajax({
        url: lookup_url,
        dataType: "json",
        delay: 1000,
        error: function(XMLHttpRequest, textStatus, errorThrown) {
              do_alert("Lookup error for programs. If your fund, organization and program values are valid, please confirm that the financial data web services are running. (" + textStatus + errorThrown + ")");
        },
        success: function (data) {

          if (data.length == 1) {
            if ( data[0].prog != "None" && data[0].prog != "Error") {
               $(prog_field).val(data[0].prog);
               $(prog_field).prop('title',data[0].prog + " - " + data[0].prog_title);
               $(prog_desc_field).val(data[0].prog_title);
            }
            else {
               if (data[0].prog == "None") {
                $(prog_field).val("No match");
                $(prog_field).prop('No Programs found for fund/org '+fund_value + '/' + orgn_value);
                $(prog_desc_field).val("Invalid Program");
               }
               else {
                 $(prog_field).val("Error");
                 $(prog_field).prop('An error occurred with the Financial Web Service. ');
                 $(prog_desc_field).prop('An error occurred with the Financial Web Service. ');
               }
            }
            $(prog_field).prop('readOnly', true);
          }
          else {
            var progs = [];
              for (i = 0; i < data.length; i++) {
                progs.push({label: data[i].prog + ' - ' + data[i].prog_title, value: data[i].prog });
              }
              $(prog_field).autocomplete({
                source: progs,
//                  source: function (request, response) {
//                    var lookup_url = "/nd_foapal_gem/fop_data/prog/f/" + fund_value + "/o/" + orgn_value;
//                    if (request.term != "")
//                      lookup_url += "/" + request.term;
//
//                    $.ajax({
//                    url: lookup_url, dataType: "json", delay: 1000,
//                      error: function(XMLHttpRequest, textStatus, errorThrown) {
//                        do_alert("Lookup error for programs. If your fund, organization and program values are valid, please confirm that the financial data web services are running. (" + errorThrown + ")");
//                       },
//                      success: function (data) {
//                        response( $.map(data, function( item) {
//                          return {
//                            label: item.prog + " - " + item.prog_title,
//                            value: item.prog
//                          }
//                        }));
//                      }
//                    });
//                  },
//                  select: function (event, ui) {
//                    this.title = ui.item.label;
//                    setDescriptionField ( "prog", this, ui.item.label)
//
//                  },
                  change: function ( event) {
//                    event.stopImmediatePropagation();
                    setFoapalPartTitle(this,"prog",event.currentTarget.value)
                    $( this ).removeClass( "ui-autocomplete-loading" )
                  },
                  minLength: 0
                })
                .focus( function() { $(this).autocomplete( "search"); });
          }
          $(prog_field).removeClass('ui-autocomplete-loading');
        }
  });

}

function loadFundData( ) {
  fundData = [];
   var lookup_url = "/nd_foapal_gem/fop_data/fund/";

   $.ajax({ url: lookup_url,
    contentType: "json",
    dataType: "json",
    type: "GET",
    error: function(XMLHttpRequest, textStatus, errorThrown) {
        do_alert("Lookup error for funds. If your fund values are valid, please confirm that the financial data web services are running. (" + errorThrown + ")");
    },
    success: function (data, status, xhr) {
      if (data.length == 0) {
        $('#fund_not_found').show();
      }
      else {
          for (i = 0; i < data.length; i++ ) {
            fundData.push({value: data[i].fund, label: data[i].fund + " - " + data[i].fund_title});
          }
          var fundFields = $(".fund_input");
          fundFields.autocomplete({
            source: fundData
          });
          $('.ui-autocomplete').addClass('f-dropdown');
      }
    }

  });

}

function loadOrgData(  fund_field, fund_value) {

  var field_id = fund_field.id;
  var field_parts = field_id.split("_");
  var org_field = "";
  for (i = 0; i < field_parts.length; i++) {
    org_field += field_parts[i] + "_";
    if ($.isNumeric(field_parts[i]) ) {
      break;
    }
  }

  org_field += "orgn";
  orgData = [];
   var lookup_url = "/nd_foapal_gem/fop_data/orgn/f/" + fund_value;


   $.ajax({ url: lookup_url,
    contentType: "json",
    dataType: "json",
    type: "GET",
    error: function(XMLHttpRequest, textStatus, errorThrown) {
        do_alert("Lookup error for organizations. If your fund and organization values are valid, please confirm that the financial data web services are running. (" + errorThrown + ")");
    },
    success: function (data, status, xhr) {
      if (data.length == 0) {
        $('#org_not_found').show();
      }
      else {
          var orgField = $("#" + org_field);
          orgField.val("");
          if (data.length == 1) {
            orgField.val(data[0].orgn);
            orgField.prop('title',data[0].orgn + " - " + data[0].orgn_title);
          }
            for (i = 0; i < data.length; i++ ) {
              orgData.push({value: data[i].org, label: data[i].orgn + " - " + data[i].orgn_title});
            }

            orgField.autocomplete({
              source: orgData
            });
            $('.ui-autocomplete').addClass('f-dropdown');

      }
    }

  });

}


function validate_foapal( fund, orgn, acct, prog, actv, locn) {

   var foapal = fund + "/" + orgn + "/" + acct + "/" + prog;
   if (actv !== "")
      foapal += "/" + actv;
   if (locn !== "")
      foapal += "/" + locn;

   var lookup_url = "/nd_foapal_gem/fop_data/validate/" + foapal;


   $.ajax({ url: lookup_url,
    contentType: "json",
    dataType: "json",
    type: "GET",
    foapal: foapal,
    async:false,
    error: function(XMLHttpRequest, textStatus, errorThrown) {
              do_alert("An error occurred during FOAP[AL] validation. Please confirm that the financial data web services are running. (" + errorThrown + ")");
    },
    success: function (data, status, xhr) {
      if (data.length == 0) {
        return('An error occurred while trying to validate FOAP[AL] values.  Please verify that the Notre Dame financial data web service is available.')
      }
      else {
          if (data[0].hasOwnProperty('overall') ) {
            if ( data[0].overall == "valid") return ("");
            var return_string = "Please check the values used for FOAP[AL] " + this.foapal.replace("/","-") + ". ";
            var invalid_parts = [];
            if ( data[0].fund == "invalid" || data[0].fund == "null") invalid_parts.push( "Fund");
            if ( data[0].orgn == "invalid" || data[0].orgn == "null") invalid_parts.push( "Organization");
            if ( data[0].acct == "invalid" || data[0].acct == "null") invalid_parts.push( "Account");
            if ( data[0].prog == "invalid" || data[0].prog == "null") invalid_parts.push( "Program");
            if ( data[0].actv == "invalid") invalid_parts.push( "Activity");
            if ( data[0].locn == "invalid") invalid_parts.push( "Location");
            var invalid_string = "";
            if (invalid_parts.length == 1) invalid_string = invalid_parts[0] + " contains an invalid value.";
            else if (invalid_parts.length > 1) invalid_string = invalid_parts.slice(0,invalid_parts.length -2).join(", ") + " and " + invalid_parts[invalid_parts.length - 1] +  "contain invalid values.";
            return (invalid_string);
          }
          else
            return('An error occurred while trying to validate FOAP[AL] values.  Please verify that the Notre Dame financial data web service is available.')




      }
    }

  });

}

function loadInitialFoapalAutocomplete () {
  var foapal_data_rows = $('#foapal_table .foapal_table_data_row');
  var foapal_fields = ["fund","orgn_data","orgn_full","acct_data","acct_full", "prog","actv","locn"];

  for (i = 0; i < foapal_data_rows.length; i++) {
    var foapal_row_object = foapal_data_rows[i];
    for (j = 0; j < foapal_fields.length; j++) {
      var field_type = foapal_fields[j];
      var field_obj = $(foapal_row_object).find('.' + field_type + '_input')[0];
      if (typeof field_obj == 'undefined') continue;
      if (field_type == 'acct_full') field_type = 'acct';
      var field_description_obj = $(foapal_row_object).find('.' + field_type + '_description_input')[0];
      if ($(field_obj).val() != "") {
        if ($(field_description_obj).val() == "")
          setFoapalPartTitle(field_obj,field_type,$(field_obj).val());
        if (field_type == "fund")   setOrgnData("rn",i,$(field_obj).val());
        if (field_type == "orgn")   setProgData("rn",i,$(field_obj).val());
      }
    }
  }
}

function setInitialAcctDataAutocomplete() {
  if (typeof acctData == 'undefined') {
    return;
  }

  if (acctData.length == 0) {
    return;
  }

    var foapal_data_rows = $('#foapal_table .foapal_table_data_row');
    acctCodes = new Array();
    for (i = 0; i < acctData.length; i++) {
      acctCodes.push(acctData[i].value);
    }
    for (i = 0; i < foapal_data_rows.length; i++) {
      var acct_data_input_element = $(foapal_data_rows[i]).find('.acct_data_input')[0];
      var current_account_value = acct_data_input_element.value;
      if (acctData.length > 1) {
        if (current_account_value != "" && acctCodes.indexOf(current_account_value) < 0) {
            acct_data_input_element.value = "";
            acct_data_input_element.title = "";
        }
        setAcctDataAutocomplete("rn",i);
        acct_data_input_element.readOnly = false;
      }
      else {
          acct_data_input_element.value = acctData[0].value;
          acct_data_input_element.title = acctData[0].label;
          acct_data_input_element.readOnly = true;
      }
    }
}

/**********************************************/
function getNewInputFieldName ( input_field, new_field_extn) {
  var field_id = input_field.id;
  var field_parts = field_id.split("_");
  var new_field = "";
  for (i = 0; i < field_parts.length; i++) {
    new_field += field_parts[i] + "_";
    if ($.isNumeric(field_parts[i]) ) {
      break;
    }
  }

  new_field += new_field_extn;
  return( new_field);
}
