# Chocolatey Send-MouseClick extension (`chocolatey-sendmouseclick.extension`)

A [Chocolatey extension](https://docs.chocolatey.org/en-us/features/extensions) providing helper functions to trigger mouse clicks (send mouse related SendInput calls). These functions may be used in Chocolatey install and uninstall scripts by declaring this package a dependency in your package's `.nuspec`.


## Installation

As the package is an extension, it gets usually installed automatically as a dependency. However, you can still install it manually:

```console
choco install chocolatey-sendmouseclick.extension
```


## Usage

To create a package with the ability to use a function from this extension, add the following to your `.nuspec` specification:

```xml
<dependencies>
  <dependency id="chocolatey-sendmouseclick.extension" version="REPLACE_WITH_MINIMUM_VERSION_USUALLY_CURRENT_LATEST" />
</dependencies>
```

It is possible to import the module directly in your `PS >`, so you can try out the main functionality directly:

```powershell
# import the modules
Import-Module "${env:ChocolateyInstall}\helpers\chocolateyInstaller.psm1"
Import-Module "${env:ChocolateyInstall}\extensions\chocolatey-sendmouseclick\*.psm1"

# get a list of all functions
Get-Command -Module 'chocolatey-sendmouseclick.extension'

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


## License, copyright

This project is under [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0). See [`LICENSE`](./LICENSE) and [`NOTICE`](./NOTICE) for details.


## Author information

This Chocolatey extension was created and is maintained by [foundata](https://foundata.com/). If you like it, you might [buy them a coffee](https://buy-me-a.coffee/chocolatey-sendmouseclick.extension/).