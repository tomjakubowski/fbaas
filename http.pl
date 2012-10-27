#!/usr/bin/perl

use strict;
use warnings;

{

package BF;

use Language::Befunge::Interpreter;

use base qw( Language::Befunge::Interpreter );

sub set_input( ) {
  my ( $s, $str ) = @_;
  my $old = $s->_get_input;
  $s->_set_input( "$str$old" );
}

sub get_input( ) {
  my ( $s ) = @_;
  return substr( $$s{"_input"}, 0, 1, '' ) if ( length $s->_get_input );
  return undef;
}

}

{

package Server;

use HTTP::Server::Simple::CGI;
use IO::String;

use base qw( HTTP::Server::Simple::CGI );

sub handle_request {
  my ( $s, $c ) = @_;

  my $path = $c->path_info;

  if ( $path =~ m(^/fizzbuzz/(\d+),(\d+)$) ) {
    my ( $start, $end ) = ( $1, $2 );

    if ( $start < 1 or $end < $start ) {
      print "HTTP/1.0 500 Internal Server Error\r\n\r\n";
    } else {

      print "HTTP/1.0 200 OK\r\nContent-type: text/plain\r\n\r\n";

      my $bf = BF->new( { "file" => "fizzbuzz.bf" } );

      $bf->set_input( join( "\r\n", $start .. $end, "" ) );
      $bf->run_code( );

    };

  } else {
    print "HTTP/1.0 404 Not Found\r\n\r\n";
  };

}

}

Server->new( 8080 )->run( );
