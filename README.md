# College Arch Backend

## General

API backend for College Arch website, written in Ruby on Rails by Paula Zhu.

You can only request the server from the following origins:

- https://www.collegearch.org
- https://college-arch.herokuapp.com/
- http://localhost:3000

## Models/Schema

### Account
- _name_: string, full name from google
- _google_id_: string, Google ID
- _email_: string, email used to login
- _image_url_: string, profile picture url from google account
- _given_name_: string, first name
- _family_name_: string, last name
- _display_name_: display name (NOT IN USE)
- _phone_: string, phone number
- _bio_: string, user bio
- _school_: string, school
- _grad_year_: integer, graduation year
- _user_type_: string, either `Mentor` or `Mentee`
- _user_id_: integer, the id of the associated `Mentor` or `Mentee` record
- belongs to a user
- has many invitations

### Mentee
- _classroom_: string, the mentee's google classroom url
- has one mentor
- has one account

### Mentor
- has many mentees
- has one account

### Newsletter Emails
- _email_: string, email

### Invitations
- belongs to an event
- belongs to a user

### Events
- _name_: string, event name
- _host_: string, event host
- _description_: string, description of event
- _link_: string, link to event (e.g. zoom link)
- _public_link_: string, link to public facebook live stream of event
- _image_url_: string, event picture url (NOT IN USE)
- _start_time_: `DateTime`, starting time
- _end_time_: `DateTime`, ending time
- has many invitations


## Masters
- `is_master` check is for endpoints having to do with the master controller
- only the following accounts have this permission
  - paulazhu@college.harvard.edu
  - reachpaulazhu@gmail.com
  - team.collegearch@gmail.com
  - tech.collegearch@gmail.com
  - programming.collegearch@gmail.com
  - llin1@college.harvard.edu
  - lindalin2812@gmail.com
  - snalani731@gmail.com


## HTTP Endpoints

_IMPORTANT: for all endpoints EXCEPT for:
  - /login
  - POST /newsletter_emails
  - GET /events/public
  - POST /mentors/master
you must pass a Google OAuth JWT authorization token. Pass via the following request header:_

`Authorization: Bearer [TOKEN]`

### Account
- _GET /login_: returns account corresponding to token
- _GET /accounts_: returns list of all accounts (MUST be `is_master`)
- _GET /accounts/:id_: returns account information corresponding to `:account_id` (MUST be same account as `current_account` or `is_master`)
- _PUT /accounts/:id_: updates account information corresponding to `:id` (MUST be same account as `current_account` or `is_master`)
- _POST /accounts/master_update_: update another person's account information corresponding to `:other_account_id` (MUST BE `is_master`)

### Mentee
- _GET /mentees_: returns list of all mentees (MUST be `is_master`)
- _POST /mentees_: create new mentee and corresponding account
  - allowed params: `:email` as the email of associated account
- _POST /mentees/match_: match a mentee with a mentor
  - allowed params: `:mentee_id, :mentor_id`
- _POST /mentees/unmatch_: unmatch a mentee from their corresponding mentor
  - allowed params: `:mentee_id`
- _POST /mentees/batch_: batch creation of new mentees and corresponding accounts
  - allowed params: `:batch_emails` as a string of emails delimited by `, `

### Mentor
- _GET /mentors_: returns list of all mentors (MUST be `is_master`)
- _POST /mentees_: create new mentor and corresponding account
  - allowed params: `:email` as the email of associated account
- _POST /mentors/batch_: batch creation of new mentors and corresponding accounts
  - allowed params: `:batch_emails` as a string of emails delimited by `, `
- _POST /mentors/master_: creation of master account
  - allowed params: `:email`, `:master_creation_password`


### Newsletter Email
- _GET /events_: returns list of all events (MUST be `is_master`)
- _POST /newsletter_emails_: create a newsletter email (AUTHORIZATION NOT NEEDED)
  - allowed params: `:email`

### Event
- _GET /events_: returns list of all events (MUST be `is_master`)
- _GET /events/public_: returns list of all `open` events
- _POST /events/:id/register_: register for an event
- _POST /events/:id/unregister_: unregister for an event
- _POST /events/:id/public_register: register publicly for an event
- _POST /events/:id/join_: join an event
- _POST /events/:id/public_join_: publicly join an event
- _POST /events_: create new event
  - allowed params: `:name, :host, :kind, :description, :link, :public_link, :start_time, :end_time, :image_url` and `:invites` as an _array of user emails_
  - NOTE: `:kind` must be either `open`, `fellows_only`, or `invite_only`
  - NOTE: `:start_time` and `:end_time` must be sent as an ISO 8601 string
- _PUT /events/:id_: edits and updates the event of `:id`
  - same allowed params as creating a new event
- _DELETE /events/:id_: destroys the event of `:id`
