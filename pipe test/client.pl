#! C:\strawberry\perl\bin\perl.exe -w
use strict;
use Win32::Pipe;




if (my $Pipe = Win32::Pipe->new($PipeName)) {
    $Pipe->Write("\nadfadfafsdf\ndasfdfdsafadsf\n");
    print "Closing...\n";
    $Pipe->Close();
}
else {
    my($Error, $ErrorText) = Win32::Pipe::Error();
    print "Error:$Error \"$ErrorText\"\n";
}

print "Done...\n";