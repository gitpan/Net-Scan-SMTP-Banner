use 5.008006;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Net::Scan::SMTP::Banner',
    VERSION_FROM      => 'lib/Net/Scan/SMTP/Banner.pm',
    PREREQ_PM         => {
				Class::Accessor::Fast => 0.22,
			},

    ($] >= 5.005 ?
      (ABSTRACT       => 'This module permit to grab the banner message from a SMTP server.',
       AUTHOR         => 'Matteo Cantoni <mcantoni@nothink.org>') : ()),
);
