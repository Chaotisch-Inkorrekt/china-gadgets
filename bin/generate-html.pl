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
my $imagePattern = '<img src="{{url}}" title="{{title}}">';
my $imageSourcePattern = '<li><a href="{{url}}">{{title}}</a></li>';
my $linkPattern = '<li><a href="{{url}}">{{title}}</a></li>';
my $readmeGadgetPattern = "| [{{gadgetId}}]({{htmlOutputPath}}) | {{title}} | {{sources}} |";
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
foreach $gadgetData (@$gadgetsData) {
	my ($gadgetMajor, $gadgetMinor) = split(/\./,$gadgetData->{'gadget'});
	if(length($gadgetMinor) > 0) {
		$gadgetMinor = ".$gadgetMinor";
	}
	my $gadgetId = sprintf($gadgetIdPattern, $gadgetMajor, $gadgetMinor);
	my $htmlOutputPath = sprintf($htmlOutputPathPattern, $gadgetId);

	###
	# Generate lines for README.md
	###
	my @readmeGadgetSourcesList = ();
	foreach $source ($gadgetData->{'sources'}->@*) {
		my $readmeGadgetSource = $readmeGadgetSourcePattern =~ s/{{url}}/$source->{'url'}/gr;
		$readmeGadgetSource =~ s/{{title}}/$source->{'title'}/g;
		push(@readmeGadgetSourcesList, $readmeGadgetSource);
	}
	my $readmeGadgetSources = join ', ', @readmeGadgetSourcesList;

	my $readmeGadget = $readmeGadgetPattern =~ s/{{gadgetId}}/$gadgetId/gr;
	$readmeGadget =~ s/{{htmlOutputPath}}/$htmlOutputPath/g;
	$readmeGadget =~ s/{{title}}/$gadgetData->{'title'}/g;
	$readmeGadget =~ s/{{sources}}/$readmeGadgetSources/g;
	push(@readmeGadgetsList, $readmeGadget);

	###
	# Generate HTML file
	###
	if (!path($htmlOutputPath)->exists) {
		my @imagesList = ();
		foreach $imageData ($gadgetData->{'images'}->@*) {
			my $image = $imagePattern =~ s/{{url}}/$imageData->{'url'}/gr;

			if (length($imageData->{'title'}) > 0) {
				$image =~ s/{{title}}/$imageData->{'title'}/g;
			} else {
				$image =~ s/{{title}}/$gadgetData->{'title'}/g;
			}
			push(@imagesList, $image);
		}
		my $images = join "\n", @imagesList;

		my @linksList = ();
		foreach $linkData ($gadgetData->{'links'}->@*) {
			my $link = $linkPattern =~ s/{{url}}/$linkData->{'url'}/gr;
			$link =~ s/{{title}}/$linkData->{'title'}/g;
			push(@linksList, $link);
		}
		my $links = join "\n", @linksList;

		my @imageSourcesList = ();
		foreach $imageSourceData ($gadgetData->{'sources'}->@*) {
			my $imageSource = $imageSourcePattern =~ s/{{url}}/$imageSourceData->{'url'}/gr;
			$imageSource =~ s/{{title}}/$imageSourceData->{'title'}/g;
			push(@imageSourcesList, $imageSource);
		}
		my $imageSources = join "\n", @imageSourcesList;

		my $episode = $episodes{$gadgetData->{'episode'}};
		my $html = $htmlTemplate =~ s/{{gadgetId}}/$gadgetData->{'gadget'}/gr;
		$html =~ s/{{episode}}/$gadgetData->{'episode'}/g;
		$html =~ s/{{gadgetTitle}}/$gadgetData->{'title'}/g;
		$html =~ s/{{episodeDate}}/$gadgetData->{'date'}/g;
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
