#===============================================================================
#
#         FILE: Address.pm
#
#  DESCRIPTION:  HTML::FormHandler Address Field for the Mover Project
#
#===============================================================================
package Mover::Form::Field::Address;

# ABSTRACT: Address Field for the mover project.

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler::Field::Compound';

our $VERSION = '0.1';

use Moose::Util::TypeConstraints;
use HTML::FormHandler::Types qw/Collapse State/;
use Regexp::Common qw /zip/;

#-------------------------------------------------------------------------------
#  Globals
#-------------------------------------------------------------------------------
my $not_too_long  = 255;
my $not_too_short = 1;
my $two_char      = 2;

my $us_states = [
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
];

#-------------------------------------------------------------------------------
#  Sub Types
#-------------------------------------------------------------------------------
subtype 'NonEmptyStr' => as 'Str' =>
  where { ( defined $_ ) && ( length($_) > 0 ) };

subtype 'NotTooLong' => as Collapse => where { length($_) < $not_too_long } =>
  message { "Must be shorter than $not_too_long characters!" };

subtype 'NotTooShort' => as Collapse => where { length $_ > $not_too_short } =>
  message { "Must be longer than $not_too_short character!" };

subtype 'TwoChar' => as 'Str' => where { length $_ == $two_char } =>
  message { "Must be $two_char characters in length!" };

coerce 'NotTooLong' => from 'NonEmptyStr' => via {
    return substr( 0, $not_too_long - 1 ) if length $_ >= $not_too_long;
};

subtype 'UsStateCode' => as 'TwoChar' => where { $_ ~~ ( keys %$us_states ) } =>
  message { $_ . ' is not a valid US state code!' };

coerce 'UsStateCode' => from
  'TwoChar' => via { return uc($_) if ( $_ ~~ ( keys %$us_states ) ) },
  from 'NonEmptyStr' => via { \&_convert_us_state_to_code($_) };

#-------------------------------------------------------------------------------
#  Attributes
#-------------------------------------------------------------------------------

has_field 'address_1' => (
    isa          => 'NotTooLong',
    label        => 'Address',
    element_attr => { placeholder => 'Street Address' },
    apply        => [Collapse],
    coerce       => 1,
    required     => 1,
    message      => { required => 'You must enter a street address!' }
);

has_field 'address_2' => (
    isa          => 'NotTooLong',
    label        => 'Address 2',
    element_attr => { placeholder => 'Apt # etc.' },
    apply        => [Collapse],
    coerce       => 1,
);

has_field 'city' => (
    isa          => 'NotTooLong',
    label        => 'City',
    element_attr => { placeholder => 'City, Town or Village' },
    apply        => [Collapse],
    required     => 1,
    message      => { required => 'You must enter a city!' }
);

has_field 'state' => (
    isa            => 'UsStateCode',
    label          => 'State',
    type           => 'Select',
    options_method => \&_options_state,
    empty_select   => '-- Select a State --',
    required       => 1,
    coerce  => 1,
    message => { required => 'You must enter a state!' }
);

has_field 'country' => (
    isa          => 'NotTooLong',
    label        => 'Country',
    element_attr => { placeholder => 'Country' },
    apply        => [Collapse],
    default      => 'USA',
    required     => 1,
    message      => { required => 'You must enter a country!' }
);

#------ Create Zip Field Type
has_field 'zip' => (
    isa          => 'NotTooLong',
    label        => 'Zip',
    element_attr => { placeholder => 'Zip or Postal Code' },
    apply        => [

        #        {
        #            when => {
        #                { 'country' => [qr/USA/i] },
        #                required => 1,
        #                message  => 'USA requires a Zip code!'
        #            }
        #        },
        {
            check   => qr/$RE{zip}{US}{-extended => ['allow']}/,
            message => 'Invalid US Zip code!'
        }
    ]
);

#------------------------------------------------------------------------------
#      For rendering without a widget wrapper.
#------------------------------------------------------------------------------
#sub render {
#    my $self   = shift;
#    my $output = $self->subfield('address_1')->render;
#    $output .= $self->subfield('address_2')->render;
#    $output .= $self->subfield('city')->render;
#    $output .= $self->subfield('state')->render;
#    $output .= $self->subfield('country')->render;
#    $output .= $self->subfield('zip')->render;
#    return $output;
#}

#------------------------------------------------------------------------------

=head2 options_state
  Builds the Options for US states. (NY New York,  AL Alabama etc).
=cut

sub _options_state {
    return $us_states;
}

#-------------------------------------------------------------------------------
#  Validate Methods
#-------------------------------------------------------------------------------
#--- Given string. If it matches a us state,  return the State Code for that
#    State.
sub _convert_us_state_to_code {
    my $in_string = shift;
    for my $state_code ( keys %$us_states ) {
        return $state_code
          if ( uc($in_string) eq uc( $us_states->{$state_code} ) );
    }
    return undef;
}

#-------------------------------------------------------------------------------
#  END
#-------------------------------------------------------------------------------
no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;
1;

