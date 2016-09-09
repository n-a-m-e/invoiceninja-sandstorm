#!/bin/bash

#go to root project directory
cd "$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"

sed --in-place='' \
        --expression='s/appTitle = (defaultText = "Example App")/appTitle = (defaultText = "Invoice Ninja")/' \
        --expression='s/appMarketingVersion = (defaultText = "0.0.0")/appMarketingVersion = (defaultText = "2.6.11")/' \
        --expression='s/#appGrid = (svg = embed "path\/to\/appgrid-128x128.svg")/appGrid = (svg = embed "app-graphics\/round_logo.svg")/' \
	--expression='s/#grain = (svg = embed "path\/to\/grain-24x24.svg")/grain = (svg = embed "app-graphics\/round_logo.svg")/' \
	--expression='s/#market = (svg = embed "path\/to\/market-150x150.svg")/market = (svg = embed "app-graphics\/round_logo.svg")/' \
	--expression='s/#marketBig = (svg = embed "path\/to\/market-big-300x300.svg")/marketBig = (svg = embed "app-graphics\/round_logo.svg")/' \
	--expression='s/website = "http:\/\/example.com"/website = "https:\/\/www.invoiceninja.com"/' \
	--expression='s/codeUrl = "http:\/\/example.com"/codeUrl = "https:\/\/github.com\/invoiceninja\/invoiceninja"/' \
	--expression='s/categories = \[\]/categories = \[office\]/' \
	--expression='s/contactEmail = "youremail@example.com"/#contactEmail = "youremail@example.com"/' \
	--expression='s/upstreamAuthor = "Example App Team"/upstreamAuthor = "Invoice Ninja Team"/' \
	--expression='s/#description = (defaultText = embed "path\/to\/description.md")/description = (defaultText = embed "description.md")/' \
	--expression='s/shortDescription = (defaultText = "one-to-three words")/shortDescription = (defaultText = "Invoicing")/' \
	--expression='s/#(width = 640, height = 480, png = embed "path\/to\/screenshot-2.png"),/(width = 1900, height = 980, png = embed "app-graphics\/invoiceninja_example_01.png"),(width = 1900, height = 980, png = embed "app-graphics\/invoiceninja_example_02.png"),(width = 1900, height = 980, png = embed "app-graphics\/invoiceninja_example_03.png")/' \
	--expression='s/#changeLog = (defaultText = embed "path\/to\/sandstorm-specific\/changelog.md")/changeLog = (defaultText = embed "changelog.md")/' \
        $PWD/sandstorm-pkgdef.capnp

