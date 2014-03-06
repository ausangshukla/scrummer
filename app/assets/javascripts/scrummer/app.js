var app = {

	"app_type" : "web",

	initUserTypeAhead : function(field_name, callback) {
		app.debug('initUserTypeAhead called ');

		// Ensure auto complete is turned off
		$(field_name).attr("autocomplete", "off");
		// Ensure focus causes selection
		$(field_name).focus(function() {
			$(this).select();
		}).mouseup(function(e) {
			$(this).select();
		});

		$(field_name).typeahead({
			items : 20,
			minLength : 2,
			source : function(query, process) {
				app.debug('initUserTypeAhead query =  ' + query);
				typeAhead = this;

				$.get('/users/search.json', {
					term : query
				}, function(data) {

					users = [];
					map = {};

					$.each(data, function(i, value) {
						user = value;
						display_val = user.first_name + ", " + user.last_name + ", " + user.email;
						map[display_val] = user;
						users.push(display_val);
					});

					app.debug(users);
					process(users);

					if (users.length > 0) {
						app.debug(users.length + " users found");
						// Ensure that the width of the dropdown is as large as the field_name
						$(field_name).parent().find(".typeahead").css("min-width", $(field_name).width() + 20);
					} else {
						app.showAlert("No User Found", "No User found with the search criteria specified.");
					}
				});

			},

			matcher : function(item) {
				return true;
			},
			updater : function(display_val) {
				var item = map[display_val]
				$(field_name).val(display_val);

				if (callback && typeof (callback) === "function") {
					// execute the callback, passing parameters as necessary
					callback(item);
				} else {
					//$(field_name).closest('form').submit();
					app.debug("Got user " + item.id);
					//window.location = "/users/" + item.id;
				}
				return display_val;
			}
		});
	},

	hideLegend : function(chart_div, legend_indexes) {
		for (var i = 0; i < legend_indexes.length; i++) {
			$($(chart_div + " .highcharts-legend-item")[legend_indexes[i]]).click();
		}
	},

	loadAjaxTab : function(e) {

		baseURL = '';
		ajaxUrl = $(e.target).attr("ajaxurl");
		//window.history.pushState('','',ajaxUrl);
		//get anchor
		app.debug("Clicked borrowerTab with " + ajaxUrl);
		if (ajaxUrl && ajaxUrl.length > 0) {
			// find the tabs target div
			pattern = /#.+/gi//use regex to get anchor(==selector)
			targetID = e.target.toString().match(pattern)[0];
			//get anchor

			//load content for selected tab
			$.blockUI();
			$(targetID).load(baseURL + ajaxUrl, function(responseText, status, req) {
				if (status !== "error") {
					app.debug("load triggered");
					//$(tab_id).tab();
				} else {
					if (responseText) {
						app.showAlert("Error", "Error loading tab: " + responseText);
					}
				}
				$.unblockUI();
				app.init($(targetID));
			});
		}
		

	},
	ajaxTabs : function(tab_id) {
		// See for explanation: http://www.mightywebdeveloper.com/coding/bootstrap-2-tabs-jquery-load-content/
		$(tab_id).bind('show', app.loadAjaxTab);
		// $(".client_menu").bind('click', app.loadAjaxTab);
	},

	debug : function(message) {
		var _debug = true;
		if (_debug && typeof console != "undefined") {
			console.log(message);
		}
	},

	showAlert : function(title, message, width, height) {
		$('#alertDialog #title').html(title);
		$('#alertDialog #message').html(message);
		$('#alertDialog').modal();

	},

	closeConfirm : function() {
		$("#confirmDialog").modal("hide");
		return true;
	},

	notAvailedCallback : function(title, message) {
		app.debug("Clicking not_availed_btn");
		$("#not_availed_btn").click();
		app.closeConfirm();
	},

	showConfirm : function(title, message, okCallback, cancelCallback, width, height) {
		$('#confirmDialog #title').html(title);
		$('#confirmDialog #message').html(message);
		$('#confirmDialog').modal();

		if (okCallback == null) {
			okCallback = app.closeConfirm;
		}
		if (cancelCallback == null) {
			cancelCallback = app.closeConfirm;
		}
		// We assign cancelCallback to be called when the dialog is closed - this is done so that
		// the cancelCallback is called even if the dialog is closed via esc or x.
		// And we attach the cancel btn to close - so that indirectly the cancelCallback will be called
		$("#confirmDialog #confirmOKBtn").unbind('click');
		$("#confirmDialog #confirmOKBtn").bind('click', okCallback);
		$("#confirmDialog #confirmCancelBtn").unbind('click');
		$("#confirmDialog #confirmCancelBtn").bind('click', cancelCallback);
	},

	init : function(div) {
		$(div).find("input,select,textarea").not("[type=submit]").jqBootstrapValidation();

		$("html").bind("ajaxStart", function() {
			$(this).addClass('busy');
		}).bind("ajaxStop", function() {
			$(this).removeClass('busy');
		});

		$(document).ajaxStop($.unblockUI);

		app.rowClick(div);

		$("[title]").tooltip();
	},

	rowClick : function(div) {
		$(div).find('.row-click tr').click(function(e) {
			if ($(this).find('a').attr('data-method') !== "put" && $(e.target).is("td")) {
				loc = $(this).find('a').attr('href');
				if (loc) {
					if ($(this).find('a').attr('target') == "_blank") {
						window.open(loc, '_blank');
					} else {
						window.location = loc;
					}
				} else {
					app.showAlert("Not Found", "Cannot view this item as it may have been deleted");
				}

			}
		}).hover(function() {
			$(this).toggleClass('hover');
		});

	},
	hideAllMultiScreens : function(parent_div_name, exclude_div) {
		app.debug('hideAllMultiScreens called with ' + parent_div_name);
		if (exclude_div !== "undefined") {
			var sel = '.multi_screen:not(' + exclude_div + ')';
			$(parent_div_name).find(sel).hide();
		} else {
			$(parent_div_name).find('.multi_screen').hide();
		}
	},

	showMultiScreen : function(parent_div_name, curr_screen, direction) {
		app.debug('showMultiScreens called with ' + parent_div_name + " : " + curr_screen);
		app.hideAllMultiScreens(parent_div_name, curr_screen);
		if (direction == "undefined") {
			direction = "right";
		}
		$(curr_screen).show("slide", {
			direction : direction
		}, 400, function() {
			$(this).blur();
		});

		//app.scrollToTop(0);
	},

	checkMultiScreenValid : function(div) {
		inputs = $(div).find("input,textarea,select").not("[type=submit],[type=image]");
		inputs.trigger("submit.validation");
		var warningsFound = 0;
		inputs.each(function(i, el) {
			var $this = $(el), $controlGroup = $this.parents(".control-group").first();
			if ($controlGroup.hasClass("warning")) {
				$controlGroup.removeClass("warning").addClass("error");
				warningsFound++;
			}
		});

		if (warningsFound > 0) {
			return false;
		} else {
			return true;
		}
	},

	setupMultiScreen : function(div) {
		// If this is a multi_screen then the next button should go to the next screen specified

		$(div).find(".nextLink").click(function(e) {
			// Check if there is a validate attr declared
			var validateScreen = $(this).attr('validate');
			if (!validateScreen || app.checkMultiScreenValid($(this).closest(".multi_screen"))) {
				// Either we dont have to validate or the validation passed
				app.showMultiScreen($(this).attr('parent'), $(this).attr('next'), $(this).attr('direction'));
			} else {
				// Oops validation failed
				app.showAlert('Incomplete Form', 'Please ensure that the fields in red are filled out');
			}
		});

	}
}

jQuery(function() {

	app.debug("jQuery init");
	app.init($("#body"));

	// IE quirk - Array.indexOf is not defined - so define it
	if (!Array.indexOf) {
		Array.prototype.indexOf = function(obj) {
			for (var i = 0; i < this.length; i++) {
				if (this[i] == obj) {
					return i;
				}
			}
			return -1;
		}
	}
	// IE quirk - String trim is undefined
	if (!String.prototype.trim) {
		String.prototype.trim = function() {
			return this.replace(/^\s+|\s+$/g, '');
		}
	}

	$.rails.allowAction = function(element) {
		var message = element.data('confirm'), answer = false, callback;
		if (!message) {
			return true;
		}

		if ($.rails.fire(element, 'confirm')) {
			myCustomConfirmBox(message, function() {
				callback = $.rails.fire(element, 'confirm:complete', [answer]);
				if (callback) {
					var oldAllowAction = $.rails.allowAction;
					$.rails.allowAction = function() {
						return true;
					};
					// For some reason when we switched to TBS
					// Only the remote links with :confirm were being processed
					// when user click Ok on the confirm popup
					// Here we force the window location if its not remote
					if ($(element).attr("data-remote") == "true") {
						app.debug("remote link clicked");
						element.trigger('click');
					} else {
						app.debug("$(element).attr('data-method') = " + $(element).attr("data-method"));
						if ($(element).attr("data-method") == "noop") {
							app.debug("noop link clicked");
						} else {
							if ($(element).attr("data-method") != undefined && $(element).attr("data-method").toLowerCase() != "get") {
								$(element).click();
							} else {
								window.location = $(element).attr("href");
							}
						}
					}

					$.rails.allowAction = oldAllowAction;
				}
			});
		}
		return false;
	}
	function myCustomConfirmBox(message, callback) {
		// Sometimes the message is the id of the div containing the html msg
		if (message.indexOf('#') == 0) {
			message = $(message).html();
		}
		app.showConfirm("Confirm", message, callback, app.confirmLinkCancelClicked);
	}


	$("html").bind("ajaxStart", function() {
		$(this).addClass('busy');
	}).bind("ajaxStop", function() {
		$(this).removeClass('busy');
	});
	$(document).ajaxStop($.unblockUI);

	
	
});
