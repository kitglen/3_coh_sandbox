(function() {

  null;

  /**
  @class AP
  @singleton
  Provides the global namespace for SDK framework classes.  Provides convenience
  methods for app management.
  */

  var AP, _ref, _ref2, _ref3, _ref4, _ref5;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; }, __slice = Array.prototype.slice;

  AP = (function() {

    function AP() {}

    /**
    @property {Object}
    Namespace for authentication/authorization classes.
    */

    AP.auth = {};

    /**
    @property {Object}
    Namespace for general utility classes.
    */

    AP.utility = {};

    /**
    @property {Object}
    Namespace for SDK model superclasses.
    */

    AP.model = {};

    /**
    @property {Object}
    Namespace for SDK collection superclasses.
    */

    AP.collection = {};

    /**
    @property {Object}
    Namespace for apps.  In most cases only one app is present.
    */

    AP.apps = {};

    /**
    Registers an app class with a given name.  The name may be used later
    for look-up.  Registering an app with a duplicate name replaces any
    existing app.
    @param {AP.Application} app the application class
    @param {String} name the name of the application
    */

    AP.registerApp = function(app, name) {
      if (app && name) return this.apps[name] = app;
    };

    /**
    Returns an app class registered under the given name.
    @param {String} name the name of the application to look up
    @return {AP.Application} the application class
    */

    AP.getApp = function(name) {
      return this.apps[name];
    };

    return AP;

  })();

  window.AP = AP;

  if ((_ref = AP.utility) == null) AP.utility = {};

  /**
  @class AP.utility.Base64
  @singleton
  @private
  Utility singleton for encoding and decoding Base64 strings.
  */

  AP.utility.Base64 = (function() {

    function Base64() {}

    /**
    @property {String}
    @private
    */

    Base64._keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

    /**
    Encodes an input string to Base64.
    @param {String} input the string to be Base64-encoded
    @return {String} a Base64-encoded string
    */

    Base64.encode = function(input) {
      var chr1, chr2, chr3, enc1, enc2, enc3, enc4, i, output;
      output = '';
      i = 0;
      input = Base64._utf8_encode(input);
      while (i < input.length) {
        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);
        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;
        if (isNaN(chr2)) {
          enc3 = enc4 = 64;
        } else {
          if (isNaN(chr3)) enc4 = 64;
        }
        output = output + this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
      }
      return output;
    };

    /**
    Decodes an input string from Base64.
    @param {String} input the string to be Base64-decoded
    @return {String} a string decoded from Base64
    */

    Base64.decode = function(input) {
      var chr1, chr2, chr3, enc1, enc2, enc3, enc4, i, output;
      output = '';
      i = 0;
      input = input.replace(/[^A-Za-z0-9\+\/\=]/g, '');
      while (i < input.length) {
        enc1 = this._keyStr.indexOf(input.charAt(i++));
        enc2 = this._keyStr.indexOf(input.charAt(i++));
        enc3 = this._keyStr.indexOf(input.charAt(i++));
        enc4 = this._keyStr.indexOf(input.charAt(i++));
        chr1 = (enc1 << 2) | (enc2 >> 4);
        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
        chr3 = ((enc3 & 3) << 6) | enc4;
        output = output + String.fromCharCode(chr1);
        if (enc3 !== 64) output = output + String.fromCharCode(chr2);
        if (enc4 !== 64) output = output + String.fromCharCode(chr3);
      }
      output = Base64._utf8_decode(output);
      return output;
    };

    /**
    @private
    */

    Base64._utf8_encode = function(string) {
      var c, n, utftext;
      string = string.replace(/\r\n/g, '\n');
      utftext = '';
      n = 0;
      while (n < string.length) {
        c = string.charCodeAt(n);
        if (c < 128) {
          utftext += String.fromCharCode(c);
        } else if ((c > 127) && (c < 2048)) {
          utftext += String.fromCharCode((c >> 6) | 192);
          utftext += String.fromCharCode((c & 63) | 128);
        } else {
          utftext += String.fromCharCode((c >> 12) | 224);
          utftext += String.fromCharCode(((c >> 6) & 63) | 128);
          utftext += String.fromCharCode((c & 63) | 128);
        }
        n++;
      }
      return utftext;
    };

    /**
    @private
    */

    Base64._utf8_decode = function(utftext) {
      var c, c1, c2, c3, i, string;
      string = '';
      i = 0;
      c = c1 = c2 = 0;
      while (i < utftext.length) {
        c = utftext.charCodeAt(i);
        if (c < 128) {
          string += String.fromCharCode(c);
          i++;
        } else if ((c > 191) && (c < 224)) {
          c2 = utftext.charCodeAt(i + 1);
          string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
          i += 2;
        } else {
          c2 = utftext.charCodeAt(i + 1);
          c3 = utftext.charCodeAt(i + 2);
          string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
          i += 3;
        }
      }
      return string;
    };

    return Base64;

  })();

  if ((_ref2 = AP.utility) == null) AP.utility = {};

  /**
  @class AP.utility.Cookie
  @singleton
  Simplifies interaction with browser cookies.
  */

  AP.utility.Cookie = (function() {

    function Cookie() {}

    /**
    @return {String} a copy of the raw cookie string
    */

    Cookie.getFromCookieStorage = function() {
      return document.cookie.toString();
    };

    /**
    Saves cookie to document cookies.
    @param {String} cookie a formatted cookie-string to save to document cookies
    */

    Cookie.saveToCookieStorage = function(cookie) {
      return document.cookie = cookie;
    };

    /**
    Formats an expiration date for a cookie string.
    @param {Integer} days number of days from today after which to expire cookie
    */

    Cookie.formatCookieStorageDate = function(days) {
      var d;
      if (days) {
        d = new Date();
        d.setTime(d.getTime() + (days * 86400000));
        return d.toGMTString();
      }
    };

    /**
    Builds a formatted cookie-string for saving to `document.cookies`.
    @param {String} n name of cookie
    @param {String} v value of cookie
    @param {Integer} days optional number of days from today after which to
    expire cookie
    */

    Cookie.buildCookieStorageString = function(n, v, days) {
      var e;
      e = '';
      if (days) e = '; expires=' + this.formatCookieStorageDate(days);
      return n + '=' + v + e + '; path=/';
    };

    /**
    Saves a cookie to `document.cookies`.
    @param {String} n name of cookie
    @param {String} v value of cookie
    @param {Integer} days optional number of days from today after which to
    expire cookie
    */

    Cookie.set = function(n, v, days) {
      var cookie;
      cookie = this.buildCookieStorageString(n, v, days);
      return this.saveToCookieStorage(cookie);
    };

    /**
    Returns a cookie with name `n` from underlaying cookie
    storage, `document.cookie`.
    @param {String} n name of cookie
    @return {String} the cookie value, if any
    */

    Cookie.get = function(n) {
      var c, ca, i, match;
      ca = this.getFromCookieStorage().split(';');
      match = n + '=';
      c = '';
      i = 0;
      while (i < ca.length) {
        c = ca[i].replace(/^\s*/, '');
        if (c.indexOf(match) === 0) return c.substring(match.length, c.length);
        i++;
      }
      return null;
    };

    Cookie.del = function(n) {
      return this.set(n, '', -1);
    };

    return Cookie;

  })();

  if ((_ref3 = AP.utility) == null) AP.utility = {};

  /**
  @class AP.utility.Validator
  Provides an extensible facility for validating arbitrary data.  While validator
  is used primarily by {@link AP.model.Model}, it may be used to
  validate any data object.
  
  Subclass validator to implement additional validation types.  Built-in
  validation types include:
  
  - `required`:  field must have a non-null value
  - `type`:  field type is consistent with the type specified in `is`
  
  Example usage:
  
      validator = new AP.utility.Validator();
      validator.data = {
        name: 'John Doe',
        age: 46
      };
      validator.validations = [{
        field: 'name',
        validate: 'required'
      }, {
        field: 'age',
        validate: 'type',
        is: 'integer'
      }];
  
      validator.validate();
      // true
      validator.data.age = null;
      validator.validate();
      // true
      // age is not required:  although "null" is not an integer, it is valid
      // because the type validator ignores null values.
      
      validator.data.name = '';
      validator.validate();
      // false
  */

  AP.utility.Validator = (function() {

    /**
    @private
    @property {Object[]}
    Internal errors array.  If the errors array contains any errors then the
    validator is considered to be in an invalid state.
    */

    Validator.prototype._errors = [];

    /**
    @private
    @property {Object}
    Internal hash of error messages.  Each key is an error type where its value
    is an error message string.
    */

    Validator.prototype._errorMessages = {
      required: 'this field is required',
      booleanType: 'this field must be a boolean',
      stringType: 'this field must be a string',
      numberType: 'this field must be a number',
      integer: 'this field must be an integer',
      float: 'this field must be a float',
      missingType: 'this field cannot be validated as type {0}'
    };

    /**
    @property {Object}
    The data object to validate.
    */

    Validator.prototype.data = {};

    /**
    @property {Object[]}
    A list of validations to apply.  Validations is an array of validation
    configuration objects.  Validation configuration objects must contain at least
    the following members:
    
    - `field`:  a key in the {@link #data} object
    - `validate`:  a string reprenting the validation type
    
    Certain validations may require additional information.  For example, the
    `type` validation requires an `is` member, the data type.
    
    For example:
    
        [
          field: 'name'
          validate: 'required'
        ,
          field: 'age'
          validate: 'type'
          is: 'integer'
        ]
    */

    Validator.prototype.validations = [];

    function Validator(data, validations) {
      this.data = data;
      this.validations = validations;
      this._errors = [];
      this.data = _.clone(this.data);
      this.validations = _.clone(this.validations);
    }

    /**
    Returns true if the validator has no errors.  **Note**:  {@link #validate}
    should be executed before calling `isValid`.  Always returns `true` if
    executed before `validate`.
    @return {Boolean} `true` if there
    */

    Validator.prototype.isValid = function() {
      return !this.errors().length;
    };

    /**
    Applies the validations specified in {@link #validations} to {@link #data},
    clearing any existing errors first.
    @return {Boolean} the return value of {@link #isValid}.
    */

    Validator.prototype.validate = function() {
      var validation, _i, _len, _ref4;
      this._errors = [];
      _ref4 = this.validations;
      for (_i = 0, _len = _ref4.length; _i < _len; _i++) {
        validation = _ref4[_i];
        if (this[validation.validate]) {
          this[validation.validate](this.data[validation.field], validation);
        }
      }
      return this.isValid();
    };

    /**
    Adds an error of `type` for field `fieldName` to the validator where `type` is
    a key in the internal {@link #_errorMessages error messages hash}.  Additional
    data may be passed as an array via `extra` which is interpolated into the
    error message.
    @param {String} fieldName the field to which the error applies
    @param {String} type the error type, corresponding to a key in the internal
    error messages hash.
    @param {String[]} [extra] optional array of strings to be interpolated into
    the error message
    */

    Validator.prototype.addError = function(fieldName, type, extra) {
      var i, message, value, _len;
      message = this._errorMessages[type] || 'is invalid';
      if (extra) {
        for (i = 0, _len = extra.length; i < _len; i++) {
          value = extra[i];
          message = message.replace("{" + i + "}", value);
        }
      }
      return this._errors.push({
        field: fieldName,
        message: message
      });
    };

    /**
    Returns the internal errors array.
    @return {String[]} the internal errors array.
    */

    Validator.prototype.errors = function() {
      return this._errors;
    };

    /**
    Validates that the value is non-null.  If null or undefined, adds an error.
    @param value the value to validate
    @param {Object} options a validation configuration object, for example:
        {field: 'title', validate: 'required'}
    */

    Validator.prototype.required = function(value, options) {
      if (value === null || value === void 0) {
        return this.addError(options.field, 'required');
      }
    };

    /**
    Validates that the value is of a specified type.  Adds an error if the value
    is not of the specified type.
    @param value the value to validate
    @param {Object} options a validation configuration object with an extra `is`
    member to specify type, for example:
        {field: 'title', validate: 'type', is: 'string'}
    */

    Validator.prototype.type = function(value, options) {
      var type;
      type = options.is.toLowerCase();
      if (this["" + type + "Type"]) {
        return this["" + type + "Type"](value, options);
      } else {
        return this.addError(options.field, 'missingType', [type]);
      }
    };

    /**
    Validates that `value` is a boolean.  Adds an error if `value` is present but
    not of type boolean.
    @param value the value to validate
    @param {Object} options a validation configuration object with an extra `is`
    member to specify type, for example:
        {field: 'title', validate: 'type', is: 'boolean'}
    */

    Validator.prototype.booleanType = function(value, options) {
      if (((typeof value) !== 'boolean') && (value !== null && value !== void 0)) {
        return this.addError(options.field, 'booleanType');
      }
    };

    /**
    Validates that `value` is a string.  Adds an error if `value` is present but
    not of type string.
    @param value the value to validate
    @param {Object} options a validation configuration object with an extra `is`
    member to specify type, for example:
        {field: 'title', validate: 'type', is: 'string'}
    */

    Validator.prototype.stringType = function(value, options) {
      if (((typeof value) !== 'string') && (value !== null && value !== void 0)) {
        return this.addError(options.field, 'stringType');
      }
    };

    /**
    Validates that `value` is a number.  Adds an error if `value` is present but
    not of type number.
    @param value the value to validate
    @param {Object} options a validation configuration object with an extra `is`
    member to specify type, for example:
        {field: 'title', validate: 'type', is: 'number'}
    */

    Validator.prototype.numberType = function(value, options) {
      if (((typeof value) !== 'number') && (value !== null && value !== void 0)) {
        return this.addError(options.field, 'numberType');
      }
    };

    /**
    Validates that `value` is a number.  Adds an error if `value` is present but
    not of type number.
    @param value the value to validate
    @param {Object} options a validation configuration object with an extra `is`
    member to specify type, for example:
        {field: 'title', validate: 'type', is: 'float'}
    */

    Validator.prototype.floatType = function(value, options) {
      if (((typeof value) !== 'number') && (value !== null && value !== void 0)) {
        return this.addError(options.field, 'floatType');
      }
    };

    /**
    Validates that `value` is a whole number.  Adds an error if `value` is present
    but not of a whole number.
    @param value the value to validate
    @param {Object} options a validation configuration object with an extra `is`
    member to specify type, for example:
        {field: 'title', validate: 'type', is: 'integer'}
    */

    Validator.prototype.integerType = function(value, options) {
      if (value !== null && value !== void 0) {
        if (!(((typeof value) === 'number') && (value.toString().indexOf('.') === -1))) {
          return this.addError(options.field, 'integerType');
        }
      }
    };

    /**
    **UNIMPLEMENTED***
    Validates that `value` is a data.
    @param value the value to validate
    @param {Object} options a validation configuration object with an extra `is`
    member to specify type, for example:
        {field: 'title', validate: 'type', is: 'date'}
    */

    Validator.prototype.dateType = function(value, options) {};

    /**
    **UNIMPLEMENTED***
    Validates that `value` is a time.
    @param value the value to validate
    @param {Object} options a validation configuration object with an extra `is`
    member to specify type, for example:
        {field: 'title', validate: 'type', is: 'time'}
    */

    Validator.prototype.timeType = function(value, options) {};

    return Validator;

  })();

  if ((_ref4 = AP.auth) == null) AP.auth = {};

  /**
  @class AP.auth.Authentication
  @singleton
  @mixins Backbone.Events
  Provides methods for user authentication and deauthentication.
  
  To login (Coffeescript):
  
      AP.auth.Authentication.login
        username: 'johndoe'
        password: 'doe123'
      
      AP.auth.Authentication.isAuthenticated()
      # true
  
  To logout:
  
      AP.auth.Authentication.logout()
      
      AP.auth.Authentication.isAuthenticated()
      # false
  */

  AP.auth.Authentication = (function() {

    function Authentication() {}

    _.extend(Authentication, Backbone.Events);

    /**
    @property {String}
    @private
    */

    Authentication.cookieDelimiter = '__DELIMITER__';

    /**
    Executes login request with passed `credentials`.
    @param {Object} credentials the user credentials
    */

    Authentication.login = function(credentials) {
      if (!this.isAuthenticated()) return this.authenticate(credentials);
    };

    /**
    Executes logout request.
    */

    Authentication.logout = function() {
      if (this.isAuthenticated()) return this.deauthenticate();
    };

    /**
    @return {Boolean} `true` if authentication is enabled
    */

    Authentication.isAuthenticatable = function() {
      return !!this.authenticatableObject;
    };

    /**
    @return {Boolean} `true` if a user is logged-in
    */

    Authentication.isAuthenticated = function() {
      return !!this.getAuthSessionData();
    };

    /**
    Performs authentication request with HTTP basic auth.  Upon a successful
    login the user object returned by the API is stored for later use.
    @param {Object} credentials user credentials object, for example:
    `{"username": "johndoe", "password": "doe123"}`.
    */

    Authentication.authenticate = function(credentials) {
      var auth_object;
      var _this = this;
      auth_object = this.getAuthenticatableObject();
      return $.ajax({
        url: auth_object.authentication_url,
        type: 'POST',
        dataType: 'text',
        data: credentials,
        beforeSend: function(request) {
          return request.setRequestHeader('Authorization', _this.makeHTTPBasicAuthHeader(credentials));
        },
        success: function(response) {
          var cookieData;
          cookieData = response ? "(" + ($.trim(response)) + ")" : '';
          cookieData = AP.utility.Base64.encode([cookieData].join(_this.cookieDelimiter));
          AP.utility.Cookie.set('ap-login', cookieData, 7);
          /**
          @event 'auth:authenticated'
          An authenticated event is triggered after a successful login.
          */
          return _this.trigger('auth:authenticated');
        },
        error: function() {
          /**
          @event 'auth:error'
          An auth error event is triggered if a login or logout fails for
          any reason.
          */          return _this.trigger('auth:error');
        }
      });
    };

    /**
    Performs deauthentication request.  Upon a successful logout, stored user data
    is removed.
    */

    Authentication.deauthenticate = function() {
      var auth_object;
      var _this = this;
      auth_object = this.getAuthenticatableObject();
      return $.ajax({
        url: auth_object.deauthentication_url,
        type: 'POST',
        dataType: 'text',
        success: function(response) {
          AP.utility.Cookie.del('ap-login');
          /**
          @event auth:deauthenticated
          A deauthenticated event is triggered after a successful logout.
          */
          return _this.trigger('auth:deauthenticated');
        },
        error: function(response) {
          return _this.trigger('auth:error');
        }
      });
    };

    /**
    @private
    Builds a Base64-encoded HTTP basic auth header for use in an
    authentication request.
    @param {Object} credentials the user credentials
    @return {String} Base-64 encoded HTTP basic auth header with user credentials
    */

    Authentication.makeHTTPBasicAuthHeader = function(credentials) {
      var auth_object, lookup, match;
      auth_object = this.getAuthenticatableObject();
      lookup = credentials[auth_object.lookup_field];
      match = credentials[auth_object.match_field];
      return "Basic " + AP.utility.Base64.encode([lookup, match].join(':'));
    };

    /**
    @private
    Returns the auth session data (a user) from cookie storage if logged in.
    @return {Object/null} the authenticated user object
    */

    Authentication.getAuthSessionData = function() {
      var cookie;
      cookie = AP.utility.Cookie.get('ap-login');
      if (cookie) {
        return eval(AP.utility.Base64.decode(cookie).split(this.cookieDelimiter)[0]);
      } else {
        return cookie;
      }
    };

    /**
    @private
    @return {Object/null} the authenticatable object if one is specified.
    Otherwise null.
    */

    Authentication.getAuthenticatableObject = function() {
      return this.authenticatableObject || null;
    };

    return Authentication;

  })();

  if ((_ref5 = AP.auth) == null) AP.auth = {};

  /**
  @class AP.auth.Authorization
  @singleton
  @mixins Backbone.Events
  Authorizes arbitrary objects against the currently logged-in user (see
  `AP.auth.Authentication`).  Any object may be made permission-based by adding
  an auth rules field.  If the currently logged-in user has _any role_ specified
  in the rules array, it is considered authorized.
  
  Example arbitrary permission-based object (Coffeescript):
  
      myObject1 =
        member1: 'foo'
        rules: [{roles: 'manager'}, {roles: 'admin'}]
      # authorized if logged-in user has _either_ `manager` _or_ `admin` roles
      
      myObject2 =
        member: 'bar'
        rules: [{roles: 'manager,admin'}]
      # authorized if logged-in user has both `manager` and `admin` roles
  
  Example usage (Coffeescript):
  
      AP.auth.Authorization.isAuthorized(myObject1.rules)
      AP.auth.Authorization.isAuthorized(myObject2.rules)
  */

  AP.auth.Authorization = (function() {

    function Authorization() {}

    /**
    @param {String} rules array of rule objects
    @return {Boolean} `true` if logged-in user has any role in at least one
    rule _or_ there are no rules
    */

    Authorization.isAuthorized = function(rules) {
      if (!(rules != null) || rules.length === 0) return true;
      return this._passesAnyRule(rules);
    };

    /**
    @private
    @param {String} rules array of rule objects
    @return {Boolean} `true` if logged-in user has any role in at least
    one rule
    */

    Authorization._passesAnyRule = function(rules) {
      var rule, _i, _len;
      for (_i = 0, _len = rules.length; _i < _len; _i++) {
        rule = rules[_i];
        if (this._passesRule(rule)) return true;
      }
      return false;
    };

    /**
    @private
    @param {String} rule rule object
    @return {Boolean} `true` if logged-in user has any roles in rule object or
    rule has no roles specified
    */

    Authorization._passesRule = function(rule) {
      return this._ruleHasNoRoles(rule) || this._hasAnyRole(rule.roles);
    };

    /**
    @private
    @param {String} rule rule object
    @return {Boolean} `true` if rule has no `roles` field
    */

    Authorization._ruleHasNoRoles = function(rule) {
      return !rule.hasOwnProperty('roles');
    };

    /**
    @private
    @param {String} roles_string string containing comma-separated role names
    @return {Boolean} `true` if logged-in user has any role in the roles string
    */

    Authorization._hasAnyRole = function(roles_string) {
      var role, user_roles, _i, _len, _ref6;
      user_roles = this._getRoles();
      _ref6 = roles_string.split(',');
      for (_i = 0, _len = _ref6.length; _i < _len; _i++) {
        role = _ref6[_i];
        if (user_roles.indexOf($.trim(role)) >= 0) return true;
      }
      if (!roles_string && AP.auth.Authentication.isAuthenticated()) return true;
      return false;
    };

    /**
    @private
    @return {String[]} array of roles for the currently logged-in user.  Returns
    an empty array if no user is logged in.
    */

    Authorization._getRoles = function() {
      var authObject, data, roles, rolesField;
      authObject = AP.auth.Authentication.getAuthenticatableObject();
      rolesField = authObject.role_field;
      data = AP.auth.Authentication.getAuthSessionData();
      roles = data && data[rolesField] ? data[rolesField].split(',') : [];
      roles.map(function(x) {
        return $.trim(x);
      });
      return roles;
    };

    return Authorization;

  })();

  null;

  /**
  @class AP.model.Model 
  @extends Backbone.Model
  Base model class.  In addition to the standard methods provided by the
  [Backbone JS model class](http://backbonejs.org/#Model), this base model
  implements full validations support.
  
  This model should be subclassed, not used directly.  For example (Coffeescript):
  
      class Person extends AP.model.Model
        @modelId: 'person'
        name: 'Person'
        urlRoot: '/person/'
        fieldDefinitions: [
          name: 'name'
          type: 'string'
        ,
          name: 'age'
          type: 'integer'
        ]
        validations: [
          field: 'name'
          validate: 'type'
          is: 'string'
        ,
          field: 'name'
          validate: 'required'
        ,
          field: 'age'
          validate: 'type'
          is: 'integer'
        ]
  
  For full model usage documentation,
  refer to [Backbone JS](http://backbonejs.org/#Model).
  */

  AP.model.Model = (function() {

    __extends(Model, Backbone.Model);

    function Model() {
      Model.__super__.constructor.apply(this, arguments);
    }

    /**
    @property {AP.utility.Validator}
    @private
    An internal reference to the validator instance used by the model instance.
    */

    Model.prototype._validator = null;

    /**
    @property {Object[]}
    An array of validation configurations.  For more information about
    validations, refer to
    the {@link AP.utility.Validator Validator documentation}.
    */

    Model.prototype.validations = [];

    Model.prototype.initialize = function() {
      this.validations = _.clone(this.validations);
      return this._validator = new AP.utility.Validator;
    };

    /**
    Simple proxy to the model's underlaying `fetch` method inherited
    from Backbone JS `Model`.
    */

    Model.prototype.reload = function() {
      return this.fetch.apply(this, arguments);
    };

    /**
    Simple proxy to the model's underlaying `destroy` method inherited
    from Backbone JS `Model`.
    */

    Model.prototype["delete"] = function() {
      return this.destroy.apply(this, arguments);
    };

    /**
    Validates the model instance and returns any errors reported by the instance's
    validator instance.
    @return {String[]} the errors array reported by the validator
    instance's {@link AP.utility.Validator#errors errors method}.
    */

    Model.prototype.errors = function() {
      this.validate();
      return this._validator.errors();
    };

    /**
    Validates the model instance and returns `true` if the instance is valid,
    otherwise `false`.
    @return {Boolean} the value reported by the validator
    instance's {@link AP.utility.Validator#isValid isValid method}.
    */

    Model.prototype.isValid = function() {
      this.validate();
      return this._validator.isValid();
    };

    /**
    Copies the instance data (or optional `values` argument) and the instance
    validations into the {@link #_validator validator instance}.  Returns
    `undefined` if values are valid, otherwise returns
    an {@link #errors errors array}.
    @param {Object} values optional hash of field name/value pairs to validate 
    against this instance's validations.  Pass `values` to validate arbitrary
    data instead of instance data.
    @return {String[]/undefined} if valid, returns `undefined` as expected by
    the underlaying [Backbone JS model class](http://backbonejs.org/#Model).
    If invalid, returns the {@link #errors errors array}.
    */

    Model.prototype.validate = function(values) {
      this._validator.data = _.extend({}, values || this.attributes);
      this._validator.validations = this.validations.slice();
      if (this._validator.validate()) {
        return;
      } else {
        return this._validator.errors();
      }
    };

    return Model;

  })();

  null;

  /**
  @class AP.collection.Collection
  @extends Backbone.Collection
  Base collection class.  In addition to the standard methods provided by the
  [Backbone JS collection class](http://backbonejs.org/#Collection), this base
  collection implements paginaton and query parameter mapping.
  
  This class should be subclassed, not used directly.  For example (Coffeescript):
  
      class People extends AP.collection.Collection
        @collectionId: 'people'
        model: Person
        apiEndpoint: '/person/'
        extraParams:
          format: 'json'
  
  For full collection usage documentation,
  refer to [Backbone JS](http://backbonejs.org/#Collection).
  */

  AP.collection.Collection = (function() {

    __extends(Collection, Backbone.Collection);

    function Collection() {
      Collection.__super__.constructor.apply(this, arguments);
    }

    /**
    @property {Object}
    Name/value pairs appended to URL of requests to server.  For example, extra
    parameters `{format: 'json'}` is passed to server as:  `/url/?format=json`.
    */

    Collection.prototype.extraParams = {};

    /**
    @property {Number}
    Current page for pagination requests.
    */

    Collection.prototype.currentPage = 1;

    /**
    @property {Number}
    Number of items to request per-page.
    */

    Collection.prototype.pageSize = 35;

    Collection.prototype.initialize = function() {
      return this.extraParams = _.clone(this.extraParams || {});
    };

    /**
    Returns the URL for this collection.  By default this is the value of the
    `apiEndpoint` member of the collection.
    @return {String} URL of this collection
    */

    Collection.prototype.url = function() {
      return this.apiEndpoint;
    };

    /**
    Copies keys in object to keys of the format `query[key_name]`  in a new
    object, where `key_name` is the original key.  Returns a new object leaving
    the original intact.  For example, an input object `{foo: 'bar'}` would
    result in an output object `{query[foo]: 'bar'}`.
    @param {Object} data name/value pairs to map to query-format
    @return {Object} a new object with mapped keys
    */

    Collection.prototype.mapQueryParams = function(data) {
      var key, query, value;
      query = {};
      for (key in data) {
        value = data[key];
        if (value) query["query[" + key + "]"] = value;
      }
      return query;
    };

    /**
    Fetches objects from the collection instance's URL.  Calls the underlaying
    [Backbone Collection.fetch method](http://backbonejs.org/#Collection-fetch).
    Note:  data from the collection's optional {@link #extraParams} is passed
    through the URL of every request.
    @param {Object} options optional request data
    @param {Object} options.data optional request parameters are passed through
    request URL as-is
    @param {Object} options.query optional query parameters are passed through
    request URL after being transformed by {@link #mapQuerParams}.
    @param args... optional additional arguments passed-through to underlaying
    [Backbone Collection.fetch method](http://backbonejs.org/#Collection-fetch).
    */

    Collection.prototype.fetch = function() {
      var args, options, query;
      options = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (options == null) options = {};
      if (options != null ? options.query : void 0) {
        query = this.mapQueryParams(options.query);
      }
      options.data = _.extend({}, this.extraParams, options.data, query);
      return Backbone.Collection.prototype.fetch.apply(this, [options].concat(args));
    };

    /**
    Convenience method calls {@link #fetch} passing `query` as query parameters.
    @param {Object} query name/value pairs passed to {@link #fetch} as query data
    */

    Collection.prototype.query = function(query) {
      return this.fetch({
        query: query
      });
    };

    /**
    Fetches all records up to and including the specified page number.
    @param {Number} page page number to fetch from server
    @param {Object} options optional options object passed-through
    to {@link #fetch}.
    @param args... optional additional arguments passed-through to {@link #fetch}.
    */

    Collection.prototype.page = function() {
      var args, limit, options, page;
      page = arguments[0], options = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      'Fetches all records up to and including the specified page.';
      if (!page || !$.isNumeric(page) || (page < 1)) page = 1;
      if (options == null) options = {};
      this.currentPage = page;
      limit = this.currentPage * this.pageSize;
      options.data = _.extend({
        limit: limit
      }, options.data);
      return this.fetch.apply(this, [options].concat(args));
    };

    /**
    Increments {@link #currentPage} and calls {@link #page}, passing the value
    of `currentPage`.
    */

    Collection.prototype.nextPage = function() {
      return this.page.apply(this, [++this.currentPage].concat(arguments));
    };

    /**
    Decrements {@link #currentPage} and calls {@link #page}, passing the value
    of `currentPage`.
    */

    Collection.prototype.previousPage = function() {
      return this.page.apply(this, [--this.currentPage].concat(arguments));
    };

    return Collection;

  })();

  null;

  /**
  @class AP.collection.ScopeCollection
  @extends AP.collection.Collection
  Similar to `AP.collection.Collection` except that query data are
  optionally mapped to alternative parameter names.  Specify query fields when
  request parameters have different names than model fields.
  
  For example (Coffeescript):
  
      class PeopleScope extends AP.collection.ScopeCollection
        @collectionId: 'people_scope'
        model: Person
        apiEndpoint: '/person/'
        extraParams:
          scope: 'scoped'
        queryFields: [
          fieldName: 'name'
          paramName: 'person_name'
        ]
  */

  AP.collection.ScopeCollection = (function() {

    __extends(ScopeCollection, AP.collection.Collection);

    function ScopeCollection() {
      ScopeCollection.__super__.constructor.apply(this, arguments);
    }

    /**
    Copies `data` to new object and replaces keys which match any `queryFields`
    mapping configurations with the alternative parameter name.  For example,
    with `queryFields` `[{fieldName: 'name', paramName: 'person_name'}] and
    input object `{name: 'John', age: 35}`, output object
    is `{person_name: 'John', age: 35}`.
    @param {Object} data name/value pairs to map
    @return {Object} a new object with mapped keys
    */

    ScopeCollection.prototype.mapQueryFieldKeys = function(data) {
      'Maps key names in data to equivalent param names in @queryFields if\nany match.  On match, original key names are not retained.  Returns a new\nobject leaving original intact.';
      var key, mapped, mappedKey, paramName, value;
      mapped = {};
      for (key in data) {
        value = data[key];
        paramName = (_.find(this.queryFields, function(field) {
          return field.fieldName === key;
        }) || {}).paramName;
        mappedKey = paramName || key;
        if (value) mapped[mappedKey] = value;
      }
      return mapped;
    };

    /**
    Fetches objects from the collection instance's URL.  All arguments are passed-
    through to {@link AP.collection.Collection#fetch}, except for `options.query`
    which is transformed first by {@link #mapQueryFieldKeys}.
    @param {Object} options optional request data
    @param {Object} options.query optional query parameters are passed through
    request URL after being transformed by {@link #mapQuerParams}
    @param args... optional additional arguments passed-through
    to {@link AP.collection.Collection#fetch}
    */

    ScopeCollection.prototype.fetch = function() {
      var args, options, query;
      options = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (options == null) options = {};
      if (options != null ? options.query : void 0) {
        query = this.mapQueryFieldKeys(options.query);
      }
      if (query) options.query = query;
      return AP.collection.Collection.prototype.fetch.apply(this, [options].concat(args));
    };

    return ScopeCollection;

  })();

  null;

  /**
  @class AP.collection.AggregateCollection
  @extends AP.collection.ScopeCollection
  Unlike a normal `AP.collection.Collection`, aggregate collections expect a
  simple integer-only response from the server.  Aggregate collections are always
  zero-length (they have no members).  They have an extra member `value`.
  */

  AP.collection.AggregateCollection = (function() {

    __extends(AggregateCollection, AP.collection.ScopeCollection);

    function AggregateCollection() {
      AggregateCollection.__super__.constructor.apply(this, arguments);
    }

    /**
    @param {Number}
    The value last returned by this collection's URL.
    */

    AggregateCollection.prototype.value = null;

    /**
    @return {Number} the value of {@link #value}
    */

    AggregateCollection.prototype.valueOf = function() {
      return this.value;
    };

    /**
    Called automatically whenever {@link AP.collection.Collection#fetch} returns.
    The response is parsed as an integer and stored in {@link #value}.  `parse`
    ignores any other data returned by the server.
    @param
    */

    AggregateCollection.prototype.parse = function(response) {
      this.value = parseInt(response, 10);
      return [];
    };

    return AggregateCollection;

  })();

  null;

  /**
  @class AP.Application
  @singleton
  Provides convenience methods common to apps.  Generally, apps are
  namespaces not intended for instantiation.
  
  All apps should inherit from this class and execute setup.  It is important to
  execute setup before adding members.
  
  For example (Coffeescript):
  
      class AppClass extends AP.Application
        @setup()
  */

  AP.Application = (function() {

    function Application() {}

    /**
    @static
    Adds static members to the class:
    
    - `name`
    - `description`
    - `models`
    - `collections`
    
    It is important to execute setup before adding members.
    */

    Application.setup = function() {
      this.name = this.name || '';
      this.description = this.description || '';
      this.models = {};
      return this.collections = {};
    };

    /**
    @static
    */

    Application.proxy = function(fn) {
      var _this = this;
      return function() {
        return fn.apply(_this, arguments);
      };
    };

    /**
    @static
    Returns a model class for this application by name or model ID.
    @param {String} str the name or ID of a model
    @return {AP.model.Model} a model class
    */

    Application.getModel = function(str) {
      return _.find(this.models, function(val, key) {
        return key === str || val.modelId === str || val.name === str;
      });
    };

    /**
    @static
    Returns a collection class for this application by name or collection ID.
    @param {String} str the name or ID of a collection
    @return {AP.collection.Collection} a collection class
    */

    Application.getCollection = function(str) {
      return _.find(this.collections, function(val, key) {
        return key === str || val.collectionId === str || val.name === str;
      });
    };

    return Application;

  })();

  null;

  /**
  @class COHSdk
  @extends AP.Application
  @singleton
  Simple namespace class for this application.
  
  Example application look-up:
  
      app = AP.getApp('COHSdk')
  
  Example model and collection look-ups:
  
      modelClass = app.getModel('modelName')
      collectionClass = app.getCollection('collectionName')
  */

  window.COHSdk = (function() {

    __extends(COHSdk, AP.Application);

    function COHSdk() {
      COHSdk.__super__.constructor.apply(this, arguments);
    }

    COHSdk.setup();

    /**
    @property {String}
    Application name.
    */

    COHSdk.name = 'COHSdk';

    /**
    @property {String}
    Application description.
    */

    COHSdk.description = 'Describe your application!';

    return COHSdk;

  })();

  null;

  /*
  Registers the app with the global {@link AP AP namespace}.
  */

  AP.registerApp(COHSdk, 'COH');

  null;

  /**
  @class COHSdk.models.Doctor
  @extends AP.model.Model
  Doctor model for application `COHSdk`.  See
  `AP.model.Model` for more information about models.
  */

  COHSdk.models.Doctor = (function() {

    __extends(Doctor, AP.model.Model);

    function Doctor() {
      Doctor.__super__.constructor.apply(this, arguments);
    }

    /**
    @property {String}
    @static
    The model ID may be used to look-up a model from an application class.
    */

    Doctor.modelId = '25';

    /**
    @property {String}
    The model name may be used to look-up a model from an application class.
    */

    Doctor.prototype.name = 'Doctor';

    /**
    @property {String}
    Server requests for model instances use this URL.
    */

    Doctor.prototype.urlRoot = '/api/v2/doctors';

    /**
    @property {Array}
    Array of field definition configurations.  Field definitions describe fields
    available on this model.
    */

    Doctor.prototype.fieldDefinitions = [
      {
        id: 139,
        name: 'id',
        label: 'id',
        type: 'integer',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 143,
        name: 'business_phone',
        label: 'business_phone',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 145,
        name: 'department',
        label: 'department',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 151,
        name: 'diseases',
        label: 'diseases',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 144,
        name: 'division',
        label: 'division',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 142,
        name: 'email',
        label: 'email',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 149,
        name: 'gender',
        label: 'gender',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 141,
        name: 'high_level',
        label: 'high_level',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 150,
        name: 'languages',
        label: 'languages',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 140,
        name: 'name',
        label: 'name',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 148,
        name: 'photo',
        label: 'photo',
        type: 'string',
        required: false,
        file_url: true,
        file_type: 'Image'
      }, {
        id: 146,
        name: 'program',
        label: 'program',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 147,
        name: 'specialty',
        label: 'specialty',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }, {
        id: 152,
        name: 'trackback_url',
        label: 'trackback_url',
        type: 'string',
        required: false,
        file_url: false,
        file_type: 'Image'
      }
    ];

    /**
    @property {Array}
    Array of field names.  Auto keys, generally such as `id`, have their values
    filled automatically by the server.  Non-auto keys are all other fields.
    */

    Doctor.prototype.nonAutoKeyFields = ['business_phone', 'department', 'diseases', 'division', 'email', 'gender', 'high_level', 'languages', 'name', 'photo', 'program', 'specialty', 'trackback_url'];

    /**
    @property {Array}
    Array of validation configurations.  See `AP.model.Model` for more information
    about validations.
    */

    Doctor.prototype.validations = [
      {
        field: 'id',
        validate: 'type',
        is: 'integer'
      }, {
        field: 'business_phone',
        validate: 'type',
        is: 'string'
      }, {
        field: 'department',
        validate: 'type',
        is: 'string'
      }, {
        field: 'diseases',
        validate: 'type',
        is: 'string'
      }, {
        field: 'division',
        validate: 'type',
        is: 'string'
      }, {
        field: 'email',
        validate: 'type',
        is: 'string'
      }, {
        field: 'gender',
        validate: 'type',
        is: 'string'
      }, {
        field: 'high_level',
        validate: 'type',
        is: 'string'
      }, {
        field: 'languages',
        validate: 'type',
        is: 'string'
      }, {
        field: 'name',
        validate: 'type',
        is: 'string'
      }, {
        field: 'photo',
        validate: 'type',
        is: 'string'
      }, {
        field: 'program',
        validate: 'type',
        is: 'string'
      }, {
        field: 'specialty',
        validate: 'type',
        is: 'string'
      }, {
        field: 'trackback_url',
        validate: 'type',
        is: 'string'
      }
    ];

    return Doctor;

  })();

  null;

  /**
  @class COHSdk.collections.DoctorAllTemp
  @extends AP.collection.ScopeCollection
  DoctorAllTempis a scope collection for application `COHSdk`.  See
  `AP.collection.ScopeCollection` for more information about scopes.
  */

  COHSdk.collections.DoctorAllTemp = (function() {

    __extends(DoctorAllTemp, AP.collection.ScopeCollection);

    function DoctorAllTemp() {
      DoctorAllTemp.__super__.constructor.apply(this, arguments);
    }

    /**
    @property {String}
    @static
    The collection ID may be used to look-up a collection from an
    application class.
    */

    DoctorAllTemp.collectionId = '111';

    /**
    @property {AP.model.Model}
    The model associated with this collection.  Results returned by server
    requests for this collection are converted into instances of this model.
    */

    DoctorAllTemp.prototype.model = COHSdk.models.Doctor;

    /**
    @property {String}
    Server requests for this collection use this URL.
    */

    DoctorAllTemp.prototype.apiEndpoint = '/api/v2/doctors';

    /**
    @property {Object}
    Name/value pairs included with every server request.  Extra parameters are
    converted to URL parameters at request-time.
    */

    DoctorAllTemp.prototype.extraParams = {
      scope: 'all_temp'
    };

    /**
    @property {Array}
    Array of query field configurations.  Query fields map model field names onto
    URL parameter names.  See `AP.collection.ScopeCollection` to learn more
    about query fields.
    */

    DoctorAllTemp.prototype.queryFields = [];

    return DoctorAllTemp;

  })();

  null;

  /**
  @class COHSdk.collections.Doctor
  @extends AP.collection.Collection
  Doctor is a collection for application
  `COHSdk`.  See `AP.collection.Collection` for more information
  about collections.
  */

  COHSdk.collections.Doctor = (function() {

    __extends(Doctor, AP.collection.Collection);

    function Doctor() {
      Doctor.__super__.constructor.apply(this, arguments);
    }

    /**
    @property {String} collectionId
    @static
    The collection ID may be used to look-up a collection from an
    application class.
    */

    Doctor.collectionId = '25';

    /**
    @property {AP.model.Model}
    The model associated with this collection.  Results returned by server
    requests for this collection are converted into instances of this model.
    */

    Doctor.prototype.model = COHSdk.models.Doctor;

    /**
    @property {String}
    Server requests for this collection use this URL.
    */

    Doctor.prototype.apiEndpoint = '/api/v2/doctors';

    return Doctor;

  })();

}).call(this);
