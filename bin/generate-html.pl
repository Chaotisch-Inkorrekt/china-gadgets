use utf8;

use Path::Tiny;
use YAML::XS 'LoadFile';

binmode STDIN, ':encoding(utf-8)';
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

my $gadgetsFile         = './data/gadgets.local.yaml';
my $episodesFile          = './data/minkorrekt-themen.unfiltered.yaml';
my $readmeTemplateFile  = './README.tpl.md';
my $readmeOutputFile  = './README.md';
my $htmlOutputDirectory = './html';
my $htmlTemplateFile    = "$htmlOutputDirectory/gadget-000.tpl.html";

my $gadgetIdPattern = '%03s%s';
my $htmlOutputPathPattern = "$htmlOutputDirectory/gadget-%s.html";
my $readmeGadgetPattern = "| [{{gadget}}]({{htmlOutputPath}}) | {{name}} | {{sources}} |";
my $readmeGadgetSourcePattern = "<{{url}}> ({{title}})";

my $gadgetsData = LoadFile($gadgetsFile);
my $episodesData = LoadFile($episodesFile);
my %episodes = ();
foreach $episode (@$episodesData) {
	$episodes{$episodes->{"episode"}} = $episode;
}

my $readmeTemplate = path($readmeTemplateFile)->slurp({binmode => ":encoding(UTF-8)"});
my $htmlTemplate = path($htmlTemplateFile)->slurp({binmode => ":encoding(UTF-8)"});

my @readmeGadgetsList = ();
foreach $gadget (@$gadgetsData) {
	my ($gadgetMajor, $gadgetMinor) = split(/\./,$gadget->{'gadget'});
	if(length($gadgetMinor) > 0) {
		$gadgetMinor = ".$gadgetMinor";
	}
	my $gadgetId = sprintf($gadgetIdPattern, $gadgetMajor, $gadgetMinor);
	my $htmlOutputPath = sprintf($htmlOutputPathPattern, $gadgetId);

	my @readmeGadgetSourcesList = ();
	foreach $source ($gadget->{'sources'}->@*) {
		my $readmeGadgetSource = $readmeGadgetSourcePattern =~ s/{{url}}/$source->{'url'}/gr;
		$readmeGadgetSource =~ s/{{title}}/$source->{'title'}/g;
		push(@readmeGadgetSourcesList, $readmeGadgetSource);
	}
	my $readmeGadgetSources = join ', ', @readmeGadgetSourcesList;

	my $readmeGadget = $readmeGadgetPattern =~ s/{{gadget}}/$gadgetId/gr;
	$readmeGadget =~ s/{{htmlOutputPath}}/$htmlOutputPath/g;
	$readmeGadget =~ s/{{name}}/$gadget->{'name'}/g;
	$readmeGadget =~ s/{{sources}}/$readmeGadgetSources/g;
	push(@readmeGadgetsList, $readmeGadget);
}

my $readmeGadgets = join "\n", @readmeGadgetsList;
$readmeTemplate =~ s/{{gadgets}}/$readmeGadgets/;

path($readmeOutputFile)->append({truncate => true}, $readmeTemplate);
