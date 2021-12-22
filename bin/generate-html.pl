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
my $imageSourcePattern = '<li><a href="{{url}}">{{title}}</a></li>';
my $linkPattern = '<li><a href="{{url}}">{{title}}</a></li>';
my $readmeGadgetPattern = "| [{{gadget}}]({{htmlOutputPath}}) | {{name}} | {{sources}} |";
my $readmeGadgetSourcePattern = "<{{url}}> ({{title}})";

my $gadgetsData = LoadFile($gadgetsFile);
my $episodesData = LoadFile($episodesFile);
my %episodes = ();
foreach $episode (@$episodesData) {
	$episodes{$episode->{"episode"}} = $episode;
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

	###
	# Generate lines for README.md
	###
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

	###
	# Generate HTML file
	###
	if (!path($htmlOutputPath)->exists) {
		my @linksList = ();
		foreach $linkData ($gadget->{'links'}->@*) {
			my $link = $linkPattern =~ s/{{url}}/$linkData->{'url'}/gr;
			$link =~ s/{{title}}/$linkData->{'title'}/g;
			push(@linksList, $link);
		}
		my $links = join "\n", @linksList;

		my @imageSourcesList = ();
		foreach $imageSourceData ($gadget->{'sources'}->@*) {
			my $imageSource = $imageSourcePattern =~ s/{{url}}/$imageSourceData->{'url'}/gr;
			$imageSource =~ s/{{title}}/$imageSourceData->{'title'}/g;
			push(@imageSourcesList, $imageSource);
		}
		my $imageSources = join "\n", @imageSourcesList;

		my $images = 'TODOs';

		my $episode = $episodes{$gadget->{'episode'}};
		my $html = $htmlTemplate =~ s/{{gadget}}/$gadget->{'gadget'}/gr;
		$html =~ s/{{episode}}/$gadget->{'episode'}/g;
		$html =~ s/{{gadgetName}}/$gadget->{'name'}/g;
		$html =~ s/{{episodeDate}}/$gadget->{'date'}/g;
		$html =~ s/{{episodeTitle}}/$episode->{'title'}/g;
		$html =~ s/{{episodeLink}}/$episode->{'link'}/g;
		$html =~ s/{{imageSources}}/$imageSources/g;
		$html =~ s/{{links}}/$links/g;
		$html =~ s/{{images}}/$images/g;

		path($htmlOutputPath)->append($html);
	}
}

my $readmeGadgets = join "\n", @readmeGadgetsList;
$readmeTemplate =~ s/{{gadgets}}/$readmeGadgets/;

path($readmeOutputFile)->append({truncate => true}, $readmeTemplate);
