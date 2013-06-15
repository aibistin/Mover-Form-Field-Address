#
#===============================================================================
#
#         FILE: test_address.t
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Austin Kenny (), aibistin.cionnaith@gmail.com
# ORGANIZATION: Carry On Coding
#      VERSION: 1.0
#      CREATED: 05/04/2013 09:04:32 AM
#     REVISION: ---
#===============================================================================
use strict;
use warnings;
use Test::More tests => 1;                      # last test to print
use Test::More;
use Data::Dump qw/dump/;
use HTML::FormHandler::Test;
use_ok('Mover::Form::Field::Address');
my $form = Mover::Form::Field::Address->new;
diag 'Got this form : ' . dump $form;
$form->process;
my $expected = '<form html>';
is_html( $form->render,  $expected,  'form renders ok' );


