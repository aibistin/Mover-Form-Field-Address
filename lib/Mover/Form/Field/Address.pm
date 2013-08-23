#===============================================================================
#
#         FILE: Module.pm
#
#  DESCRIPTION:  HTML::FormHandler Address Role for the Mover Project
#
#===============================================================================
package Mover::Form::Role::Address;
# ABSTRACT: Address Field for the mover project.

use Modern::Perl;
use HTML::FormHandler::Moose::Role;
use namespace::autoclean;

our $VERSION='0.1';
$VERSION = eval $VERSION;

use HTML::FormHandler::Types qw/Zip Trim Collapse/;
#use Regexp::Common qw /zip/; 
#------------------------------------------------------------------------------
has_field 'address_1' => (
    is      => 'rw', 
    isa     => Collapse, 
    required => 0,
    message  => {
        required => 'You must enter a street address!'
    }
);
has_field 'address_2' => (is => 'rw', isa => Collapse);
has_field 'city' => (is => 'rw', isa => Collapse);
has_field 'state' => ( type => 'Select', options_method => \&_options_state );
has_field 'country' => (is => 'rw', isa => Collapse);
#------ Create Zip Field Type
has_field 'zip' => ( is => 'rw',  isa => Zip);
#------------------------------------------------------------------------------
=head2 options_state
  Builds the Options for US states. (NY New York,  AL Alabama etc).
=cut

sub _options_state {

    return (
        'AL' => 'Alabama',
        'AK' => 'Alaska',
        'AZ' => 'Arizona',
        'AR' => 'Arkansas',
        'CA' => 'California',
        'CO' => 'Colorado',
        'CT' => 'Connecticut',
        'DE' => 'Delaware',
        'FL' => 'Florida',
        'GA' => 'Georgia',
        'HI' => 'Hawaii',
        'ID' => 'Idaho',
        'IL' => 'Illinois',
        'IN' => 'Indiana',
        'IA' => 'Iowa',
        'KS' => 'Kansas',
        'KY' => 'Kentucky',
        'LA' => 'Louisiana',
        'ME' => 'Maine',
        'MD' => 'Maryland',
        'MA' => 'Massachusetts',
        'MI' => 'Michigan',
        'MN' => 'Minnesota',
        'MS' => 'Mississippi',
        'MO' => 'Missouri',
        'MT' => 'Montana',
        'NE' => 'Nebraska',
        'NV' => 'Nevada',
        'NH' => 'New Hampshire',
        'NJ' => 'New Jersey',
        'NM' => 'New Mexico',
        'NY' => 'New York',
        'NC' => 'North Carolina',
        'ND' => 'North Dakota',
        'OH' => 'Ohio',
        'OK' => 'Oklahoma',
        'OR' => 'Oregon',
        'PA' => 'Pennsylvania',
        'RI' => 'Rhode Island',
        'SC' => 'South Carolina',
        'SD' => 'South Dakota',
        'TN' => 'Tennessee',
        'TX' => 'Texas',
        'UT' => 'Utah',
        'VT' => 'Vermont',
        'VA' => 'Virginia',
        'WA' => 'Washington',
        'WV' => 'West Virginia',
        'WI' => 'Wisconsin',
        'WY' => 'Wyoming',
    );

}

#-------------------------------------------------------------------------------
#  Validate Methods
#-------------------------------------------------------------------------------
=head2 validate_zip
 Called automatically to validate Zip Code using Regexp::Common qw/zip/.
=cut
#sub validate_zip{
#    my ( $self,  $field_zip ) = @_; # self is the form
#    if ( $field_zip->value eq $RE{zip}{US}{ extended => 'allow'}  ) {
#                $field_zip->add_error( '...' );
#            }
#
#}

#-------------------------------------------------------------------------------
#  END
#-------------------------------------------------------------------------------
no HTML::FormHandler::Moose::Role;
1;

