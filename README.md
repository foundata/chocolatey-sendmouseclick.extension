# Send-MouseClick extension for Chocolatey (`sendmouseclick.extension`)

**This project is *not* associated with the official [Chocolatey](https://chocolatey.org/) product or team, nor with [Chocolatey Software, Inc.](https://chocolatey.org/contact/).**

A [Chocolatey extension](https://docs.chocolatey.org/en-us/features/extensions) providing helper functions to send mouse clicks (mouse related SendInput calls). These functions may be used in Chocolatey install and uninstall scripts by declaring this package a dependency in your package's `.nuspec`.


## Installation

As the package is an extension, it gets usually installed automatically as a dependency. However, you can still install it manually:

```console
choco install sendmouseclick.extension
```


## Usage

To create a package with the ability to use a function from this extension, add the following to your `.nuspec` specification:

```xml
<dependencies>
  <dependency id="sendmouseclick.extension" version="REPLACE_WITH_MINIMUM_VERSION_USUALLY_CURRENT_LATEST" />
</dependencies>
```

It is possible to import the module directly in your `PS >`, so you can try out the main functionality directly:

```powershell
# import the modules
Import-Module "${env:ChocolateyInstall}\helpers\chocolateyInstaller.psm1"
Import-Module "${env:ChocolateyInstall}\extensions\sendmouseclick\*.psm1"

# get a list of all functions
Get-Command -Module 'sendmouseclick.extension'

# get help and examples for a specific function
Get-Help Send-MouseClick -Detailed

# left-click on the center of the current primary screen (implies -Position 'Center')
Send-MouseClick

# left-click at the current cursor position
Send-MouseClick -Position $null

# bring the first window that contains the name 'foo' to the front, focus it and
# left-click on the center of the current primary screen
Send-MouseClick -Query 'foo'

# left-click at the position X100, Y200 of the current primary screen
Send-MouseClick -Position (100, 200)

# bring the first window that equals the name 'foo' to the front, focus it and
# left-click on the center of the current primary screen
Send-MouseClick -Query '^foo$'
```

But keep in mind that functions of Chocolatey extension may only work correctly in the context of Chocolatey install and uninstall scripts.


## Licensing, copyright

<!--REUSE-IgnoreStart-->
Copyright (c) 2023, 2024 foundata GmbH (https://foundata.com)

This project is licensed under the Apache License 2.0 (SPDX-License-Identifier: `Apache-2.0`), see [`LICENSES/Apache-2.0.txt`](LICENSES/Apache-2.0.txt) for the full text.

The [`.reuse/dep5`](.reuse/dep5) file provides detailed licensing and copyright information in a human- and machine-readable format. This includes parts that may be subject to different licensing or usage terms, such as third party components. The repository conforms to the [REUSE specification](https://reuse.software/spec/), you can use [`reuse spdx`](https://reuse.readthedocs.io/en/latest/readme.html#cli) to create a [SPDX software bill of materials (SBOM)](https://en.wikipedia.org/wiki/Software_Package_Data_Exchange).
<!--REUSE-IgnoreEnd-->

[![REUSE status](https://api.reuse.software/badge/github.com/foundata/chocolatey-sendmouseclick.extension)](https://api.reuse.software/info/github.com/foundata/chocolatey-sendmouseclick.extension)


## Author information

This Chocolatey extension was created and is maintained by [foundata](https://foundata.com/). If you like it, you might [buy them a coffee](https://buy-me-a.coffee/chocolatey-sendmouseclick.extension/). This is a community project and *not* associated with the official [Chocolatey](https://chocolatey.org/) product or team, nor with [Chocolatey Software, Inc.](https://chocolatey.org/contact/).
