#! C:\strawberry\perl\bin\perl.exe -w
use strict;
use Win32::Pipe;

my $PipeName = "pdf_gen";

while () {
    if (my $Pipe = new Win32::Pipe($PipeName)) {
	while ($Pipe->Connect()) {
	    my $In = $Pipe->Read();
		print $In;
	    
	    $Pipe->Disconnect();
	}
	$Pipe->Close();
    }
}

