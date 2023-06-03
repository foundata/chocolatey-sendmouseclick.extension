function Send-MouseClick {
    <#
    .SYNOPSIS
        Sends mouse clicks to the active application with optional, automatic window
        focus and optional delays (before and after clicking). Mostly a wrapper
        around different mouse click related user32.dll SendInput calls.

    .LINK
        https://docs.microsoft.com/en-us/dotnet/desktop/winforms/input-mouse/how-to-simulate-events
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False,
                   HelpMessage = 'Where to send the click (this does not move the cursor, only sending the click as it would have been moved there and back to the original position). Use $False, $null or an empty string to send the click at the current cursor position. Use the string "Center" to send the click to the center of the current primary screen. User an array of integers (x, y) to define coordinates as you whish. Defaults to "Center".')]
        $Position = 'Center',

        [Parameter(Mandatory = $False,
                   HelpMessage = 'What kind of mouse click to send. Defaults to "Left".')]
        [ValidateSet('Left')]
        [String]$Type = 'Left',

        [Parameter(Mandatory = $False,
                   HelpMessage = 'Array of integers. Seconds to wait before executing the mouse event and afterwards. Defaults to (0, 2).')]
        [ValidateScript({
            if (!($Delay -is [array]) -or ($Delay.count -ne 2)) {
                Throw 'Send-MouseClick: -Delay has to be an array of integers with two elements.'
            } else {
                $True
            }
        })]
        [Array]$Delay = @(0, 2),

        [Parameter(Mandatory = $False,
                   HelpMessage = 'An optional -Query for Use-Window (which will be called before the mouse click if a query is given).')]
        [String]$Query = ''
    )

    Begin {
        if (!(Test-Path variable:SendMouseClickInitDone -ErrorAction 'SilentlyContinue')) {
            Add-Type -AssemblyName System.Drawing
            Add-Type -AssemblyName System.Windows.Forms
            Set-Variable -Name 'SendMouseClickInitDone' -Value $True -Option 'Constant' -Scope 'Global' -Force
        }
    }

    Process {
        $Coordinates = @(0, 0)
        switch ($Position) {
            # center of primary screen
            'Center' {
                # TODO Check if this is DPI aware, not tested yet. Cf. bit.ly/3E7L4Z3, bit.ly/3hsEySV
                # TODO Check if PrimaryScreen.WorkingArea is better (which returns the desktop area
                #      of the display, excluding taskbars, docked windows, and docked tool bars)?
                #      Clarify where do new windows get placed? Center of screen or working area?
                #      Cf. System.Windows.WindowStartupLocation.CenterScreen
                $Coordinates[0] = [int]([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width / 2)
                $Coordinates[1] = [int]([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height / 2)
            }

            # user defined position
            {(($Position -is [array]) -and ($Position.count -eq 2))} {
                $Coordinates[0] = [int]$Position[0]
                $Coordinates[1] = [int]$Position[1]
            }

            # cursor's current position
            {($Position -eq $False -or ([string]::IsNullOrEmpty($Position)))} {
                $Coordinates[0] = [int]([System.Windows.Forms.Cursor]::Position.X)
                $Coordinates[1] = [int]([System.Windows.Forms.Cursor]::Position.Y)
            }

            default { Throw ('Send-MouseClick: Unknown position "{0}"' -f "${Position}") }
        }

        # force integer casting
        $Delay[0] = [int]$Delay[0]
        $Delay[1] = [int]$Delay[1]

        # delay before
        if ($Delay[0] -gt 0) {
            Write-Host ('Send-MouseClick: Will wait {0} seconds (delay before sending the click(s)).' -f $Delay[0])
            Start-Sleep $Delay[0]
        }

        # bring to front and activate a target window
        if ($Query -ne $False -and !([string]::IsNullOrEmpty($Query))) {
            Use-Window -Query $Query
        }

        Write-Host ('Send-MouseClick: "{0}" click at (X{1}, Y{2}).' -f "${Type}", $Coordinates[0], $Coordinates[1])
        switch ($Type) {
            'Left' { [MouseClick]::LeftClickAtPoint($Coordinates[0], $Coordinates[1]) }
            # 'LeftDouble' { FIXME to be implemented }
            # 'Right' { FIXME to be implemented }
            default { Throw ('Send-MouseClick: Unknown click type "{0}"' -f "${Type}") }
        }

        # delay after
        if ($Delay[1] -gt 0) {
            Write-Host ('Send-MouseClick: Will wait {0} seconds (delay after sending the click(s)).' -f $Delay[1])
            Start-Sleep $Delay[1]
        }
    }

    End { }
}