#!/usr/bin/perl
#
##
# Linux Malware Detect v1.4.1-wt-0
#             (C) 2013, Chris James <chris@wiredtree.com>
#             (C) 2002-2011, R-fx Networks <proj@r-fx.org>
#             (C) 2011, Ryan MacDonald <ryan@r-fx.org>
# inotifywait (C) 2007, Rohan McGovern  <rohan@mcgovern.id.au>
# This program may be freely redistributed under the terms of the GNU GPL v2
##
#

$named_pipe_name = "/usr/local/maldetect/hexfifo";
$timeout = "3";

if (-p $named_pipe_name) {
    eval {
      local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required
      alarm $timeout;
      if (sysopen(FIFO, $named_pipe_name, O_RDONLY)) {
        while(my $this_line = <FIFO>) {
          chomp($this_line);
          $return .= $this_line;
        }
        close(FIFO);
      } else {
        $errormsg = "ERROR: Failed to open named pipe $named_pipe_name for reading: $!";
      }
      alarm 0;
    };
    if ($@) {
      if ($@ eq "alarm\n") {
        # timed out
        $errormsg = "Timed out reading from named pipe $named_pipe_name";
      } else {
        $errormsg = "Error reading from named pipe: $!";
      }
    } else {
      # didn't time out
      $instr = $return;
    }
 }

$dat_hexstring="/usr/local/maldetect/sigs/hex.dat";
open(DAT, $dat_hexstring) || die("Could not open $dat_hexstring");
@raw_data=<DAT>;
close(DAT); 

foreach $hexptr (@raw_data) {
 chomp($hexptr);
 ($ptr,$name)=split(/:/,$hexptr);
 if ( grep(/$ptr/, $instr) ) {
 	print "$ptr $name \n";
	exit;
 }
}
