
## SYNTAX VALIDATION
##
## This test script should only be used for syntax checks.
## Please insert here all unusual distinguished names which you know.
## Good examples are inspired from the italian signature law and
## from the globus toolkit. If you have a new special DN then send
## it to us and we include it.

use strict;
use warnings;
use Test;
use OpenXPKI::DN;

my %example = (
    ## normal DN
    "CN=max mustermann,OU=employee,O=university,C=de" => 
        [
         [ ["CN", "max mustermann"] ],
         [ ["OU", "employee"] ],
         [ ["O",  "university"] ],
         [ ["C",  "de"] ]
        ],
    ## Italian signature law
    "CN=name=max/birthdate=26091976,OU=unit,O=example,C=it" =>
        [
         [ ["CN", "name=max/birthdate=26091976"] ],
         [ ["OU", "unit"] ],
         [ ["O",  "example"] ],
         [ ["C",  "it"] ]
        ],
    ## mutlivalued RDN
    "CN=Max Mustermann+UID=123456,OU=unit,O=example,C=uk" =>
        [
         [
          ["CN",  "Max Mustermann"],
          ["UID", "123456"]
         ],
         [ ["OU", "unit"] ],
         [ ["O",  "example"] ],
         [ ["C",  "uk"] ]
        ],
    ## + is a normal character here
    "CN=Max Mustermann\\+uid=123456,OU=unit,O=example,C=uk" =>
        [
         [ ["CN", "Max Mustermann+uid=123456"] ],
         [ ["OU", "unit"] ],
         [ ["O",  "example"] ],
         [ ["C",  "uk"] ]
        ],
    ## globus toolkit http
    "CN=http/www.example.com,O=university,C=ar" =>
        [
         [ ["CN", "http/www.example.com"] ],
         [ ["O",  "university"] ],
         [ ["C",  "ar"] ]
        ],
    ## globus toolkit ftp
    "CN=ftp/ftp.example.com,O=university,C=ar" =>
        [
         [ ["CN", "ftp/ftp.example.com"] ],
         [ ["O",  "university"] ],
         [ ["C",  "ar"] ]
        ],
              );

BEGIN { plan tests => 58 };

print STDERR "SYNTAX VALIDATION\n";

foreach my $dn (keys %example)
{
    ## init object

    my $object = OpenXPKI::DN->new ($dn);
    if ($object)
    {
        ok (1);
    } else {
        ok (0);
    }
    ok ($object->get_rfc_2253_dn(), $dn);

    my @attr = $object->get_parsed();

    ## validate parsed structure

    for (my $i=0; $i < scalar @{$example{$dn}}; $i++)
    {
        ## we are at RDN level now
        for (my $k=0; $k < scalar @{$example{$dn}[$i]}; $k++)
        {
            ## we are at attribute level now
            ok ($attr[$i][$k]->[0], $example{$dn}[$i][$k][0]);
            ok ($attr[$i][$k]->[1], $example{$dn}[$i][$k][1]);
        }
    }
}

1;
