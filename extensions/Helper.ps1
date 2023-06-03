Add-Type -Language 'CSharp' -ReferencedAssemblies @('System', 'System.Drawing', 'System.Runtime.InteropServices', 'System.Windows.Forms') -TypeDefinition @"
    using System;
    using System.Drawing;
    using System.Runtime.InteropServices;
    using System.Windows.Forms;

    public static class MouseClick
    {
        // More info on INPUT structure (winuser.h):
        // https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-input
        [StructLayout(LayoutKind.Sequential)]
        public struct INPUT
        {
            public int type; // 0 = INPUT_MOUSE, 1 = INPUT_KEYBOARD, 2 = INPUT_HARDWARE
            public MOUSEINPUT mInput;
        }

        // More info on MOUSEINPUT structure (winuser.h):
        // https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-mouseinput
        [StructLayout(LayoutKind.Sequential)]
        public struct MOUSEINPUT
        {
            public int dx;
            public int dy;
            public int mouseData;
            public int dwFlags;
            public int time;
            public IntPtr dwExtraInfo;
        }

        // See https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-mouseinput
        // for info about the following bit flags that specify various aspects of mouse motion,
        // button clicks and other mouse events or functions.
        private const int MOUSEEVENTF_ABSOLUTE = 0x8000;
        private const int MOUSEEVENTF_HWHEEL = 0x1000;
        private const int MOUSEEVENTF_LEFTDOWN = 0x0002;
        private const int MOUSEEVENTF_LEFTUP = 0x0004;
        private const int MOUSEEVENTF_MIDDLEDOWN = 0x0020;
        private const int MOUSEEVENTF_MIDDLEUP = 0x0040;
        private const int MOUSEEVENTF_MOVE = 0x0001;
        private const int MOUSEEVENTF_RIGHTDOWN = 0x0008;
        private const int MOUSEEVENTF_RIGHTUP = 0x0010;
        private const int MOUSEEVENTF_WHEEL = 0x0080;
        private const int MOUSEEVENTF_XDOWN = 0x0100;
        private const int MOUSEEVENTF_XUP = 0x0200;

        [DllImport("user32.dll")]
        extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

        public static void LeftClickAtPoint(int x, int y)
        {
            // move
            INPUT[] input = new INPUT[3];
            input[0].mInput.dx = x * (65535 / System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
            input[0].mInput.dy = y * (65535 / System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
            input[0].mInput.dwFlags = MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE;

            // left button down
            input[1].mInput.dwFlags = MOUSEEVENTF_LEFTDOWN;

            // left button up
            input[2].mInput.dwFlags = MOUSEEVENTF_LEFTUP;
            SendInput(3, input, Marshal.SizeOf(input[0]));
        }
    }
"@