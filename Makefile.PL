use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'Algorithm::Interval2Prefix',
    VERSION_FROM => 'Interval2Prefix.pm',
    PREREQ_PM    => {Test::More => 0},
);
