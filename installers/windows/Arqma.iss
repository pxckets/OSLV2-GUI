; Oscillate Devils Touch Installer for Microsoft Windows Operating Systems
; Copyright (c) 2018-2019, The Oscillate Network
; Copyright (c) 2014-2018, The Monero Project
; See LICENSE

[Setup]
AppName=Oscillate GUI Wallet
; For InnoSetup this is the property that uniquely identifies the application as such
; Thus it's important to keep this stable over releases
; With a different "AppName" InnoSetup would treat a mere update as a completely new application and thus mess up

AppVersion=0.5
DefaultDirName={pf}\Oscillate GUI Wallet
DefaultGroupName=Oscillate GUI Wallet
UninstallDisplayIcon={app}\oscillate-wallet-gui.exe
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64
WizardSmallImageFile=WizardSmallImage.bmp
WizardImageFile=WelcomeImage.bmp
DisableWelcomePage=no
LicenseFile=LICENSE
AppPublisher=ArQmA Network
AppPublisherURL=https://oscillate.com
OutputBaseFilename=Oscillate-WinGUI

UsedUserAreasWarning=yes
; The above directive silences the following compiler warning:
;    Warning: The [Setup] section directive "PrivilegesRequired" is set to "admin" but per-user areas (HKCU,userdocs)
;    are used by the script. Regardless of the version of Windows, if the installation is administrative then you should
;    be careful about making any per-user area changes: such changes may not achieve what you are intending.
; Background info:
; This installer indeed asks for admin rights so the Oscillate files can be copied to a place where they have at least
; a minimum of protection against changes, e.g. by malware, plus it handles things for the currently logged-in user
; in the registry (GUI wallet per-user options) and for some of the icons. For reasons too complicated to fully explain
; here this does not work as intended if the installing user does not have admin rights and has to provide the password
; of a user that does for installing: The settings of the admin user instead of those of the installing user are changed.
; Short of ripping out that per-user functionality the issue has no suitable solution. Fortunately, this will probably
; play a role in only in few cases as the first standard user in a Windows installation does have admin rights.
; So, for the time being, this installer simply disregards this problem.


[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
; Without localized versions of special forms, messages etc. of the installer, and without translated ReadMe's
; it probably does not make much sense to offer other install-time languages beside English
; Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
; Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
; Name: "jp"; MessagesFile: "compiler:Languages\Japanese.isl"
; Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
; Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"


[Files]
; The use of the flag "ignoreversion" for the following entries leads to the following behaviour:
; When updating / upgrading an existing installation ALL existing files are replaced with the files in this
; installer, regardless of file dates, version info within the files, or type of file (textual file or
; .exe/.dll file possibly with version info).
;
; This is far more robust than relying on version info or on file dates (flag "comparetimestamp").
; As of version 0.1.1.0, the oscillate .exe files do not carry version info anyway in their .exe headers.
; The only small drawback seems to be somewhat longer update times because each and every file is
; copied again, even if already present with correct file date and identical content.
;
; Note that it would be very dangerous to use "ignoreversion" on files that may be shared with other
; applications somehow. Luckily this is no issue here because ALL files are "private" to Oscillate.

Source: "ReadMe.htm"; DestDir: "{app}"; Flags: ignoreversion
Source: "FinishImage.bmp"; Flags: dontcopy

; Oscillate GUI wallet
Source: "bin\oscillate-wallet-gui.exe"; DestDir: "{app}"; Flags: ignoreversion

; Oscillate GUI wallet log file
; The GUI wallet does not have the "--log-file" command-line option of the CLI wallet and insists to put the .log beside the .exe
; so pre-create the file and give the necessary permissions to the wallet to write into it
; Flag is "onlyifdoesntexist": We do not want to overwrite an already existing log
Source: "oscillate-wallet-gui.log"; DestDir: "{app}"; Flags: onlyifdoesntexist; Permissions: users-modify

; Oscillate CLI wallet
Source: "bin\oscillate-wallet-cli.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-gen-trusted-multisig.exe"; DestDir: "{app}"; Flags: ignoreversion

; Oscillate wallet RPC interface implementation
Source: "bin\oscillate-wallet-rpc.exe"; DestDir: "{app}"; Flags: ignoreversion

; Oscillate daemon
Source: "bin\oscillated.exe"; DestDir: "{app}"; Flags: ignoreversion

; Oscillate daemon wrapped in a batch file that stops before the text window closes, to see any error messages
Source: "oscillate-daemon.bat"; DestDir: "{app}"; Flags: ignoreversion;

; Oscillate blockchain utilities
Source: "bin\oscillate-blockchain-export.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-blockchain-import.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-blockchain-mark-spent-outputs.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-blockchain-usage.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-blockchain-import.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-blockchain-ancestry.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-blockchain-depth.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-blockchain-prune.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-blockchain-prune-known-spent-data.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\oscillate-generate-ssl-certificate.exe"; DestDir: "{app}"; Flags: ignoreversion

; Various .qm files for translating the wallet UI "on the fly" into all supported languages
Source: "bin\translations\*"; DestDir: "{app}\translations"; Flags: recursesubdirs ignoreversion

; Core Qt runtime
; Use wildcards to deal with differences in those files between Qt version, like
;  "Qt5MultimediaQuick_p.dll" versus "Qt5MultimediaQuick.dll" and "Qt5RemoteObjects.dll" as new file
Source: "bin\Qt5*.dll"; DestDir: "{app}"; Flags: ignoreversion

; Qt QML elements like the local files selector "FolderListModel" and "Settings"
Source: "bin\Qt\*"; DestDir: "{app}\Qt"; Flags: recursesubdirs ignoreversion

; Qt audio support
Source: "bin\audio\*"; DestDir: "{app}\audio"; Flags: recursesubdirs ignoreversion

; Qt bearer / network connection management
Source: "bin\bearer\*"; DestDir: "{app}\bearer"; Flags: recursesubdirs ignoreversion

; Qt Windows platform plugins
Source: "bin\platforms\*"; DestDir: "{app}\platforms"; Flags: recursesubdirs ignoreversion
Source: "bin\platforminputcontexts\*"; DestDir: "{app}\platforminputcontexts"; Flags: recursesubdirs ignoreversion
Source: "bin\styles\*"; DestDir: "{app}\styles"; Flags: recursesubdirs ignoreversion

; Qt support for SVG icons
Source: "bin\iconengines\*"; DestDir: "{app}\iconengines"; Flags: recursesubdirs ignoreversion

; Qt support for various image formats (JPEG, BMP, SVG etc)
Source: "bin\imageformats\*"; DestDir: "{app}\imageformats"; Flags: recursesubdirs ignoreversion

; Qt multimedia support
Source: "bin\QtMultimedia\*"; DestDir: "{app}\QtMultimedia"; Flags: recursesubdirs ignoreversion
Source: "bin\mediaservice\*"; DestDir: "{app}\mediaservice"; Flags: recursesubdirs ignoreversion

; Qt support for "m3u" playlists
; candidate for elimination? Don't think the GUI wallet needs such playlists
Source: "bin\playlistformats\*"; DestDir: "{app}\playlistformats"; Flags: recursesubdirs ignoreversion

; Qt graphical effects as part of the core runtime, effects like blurring and blending
Source: "bin\QtGraphicalEffects\*"; DestDir: "{app}\QtGraphicalEffects"; Flags: recursesubdirs ignoreversion

; Qt "private" directory with "effects"
Source: "bin\private\*"; DestDir: "{app}\private"; Flags: recursesubdirs ignoreversion

; Qt QML files
Source: "bin\QtQml\*"; DestDir: "{app}\QtQml"; Flags: recursesubdirs ignoreversion

; Qt Quick files
Source: "bin\QtQuick\*"; DestDir: "{app}\QtQuick"; Flags: recursesubdirs ignoreversion
Source: "bin\QtQuick.2\*"; DestDir: "{app}\QtQuick.2"; Flags: recursesubdirs ignoreversion

; Qt Quick Controls 2 modules of the Qt Toolkit
Source: "bin\Material\*"; DestDir: "{app}\Material"; Flags: recursesubdirs ignoreversion
Source: "bin\Universal\*"; DestDir: "{app}\Universal"; Flags: recursesubdirs ignoreversion

; Qt Quick 2D Renderer fallback for systems / environments with "low-level graphics" i.e. without 3D support
Source: "bin\scenegraph\*"; DestDir: "{app}\scenegraph"; Flags: recursesubdirs ignoreversion
Source: "bin\start-low-graphics-mode.bat"; DestDir: "{app}"; Flags: ignoreversion

; Mesa, open-source OpenGL implementation; part of "low-level graphics" support
Source: "bin\opengl32sw.dll"; DestDir: "{app}"; Flags: ignoreversion

; Microsoft Direct3D runtime
Source: "bin\D3Dcompiler_47.dll"; DestDir: "{app}"; Flags: ignoreversion

; bzip2 support
Source: "bin\libbz2-1.dll"; DestDir: "{app}"; Flags: ignoreversion

; ANGLE ("Almost Native Graphics Layer Engine") support, as used by Qt
Source: "bin\libEGL.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libGLESV2.dll"; DestDir: "{app}"; Flags: ignoreversion

; FreeType font engine, as used by Qt
Source: "bin\libfreetype-6.dll"; DestDir: "{app}"; Flags: ignoreversion

; GCC runtime, x64 version
Source: "bin\libgcc_s_seh-1.dll"; DestDir: "{app}"; Flags: ignoreversion

; GLib, low level core library e.g. for GNOME and GTK+
; Really needed under Windows?
Source: "bin\libglib-2.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion

; Graphite font support
; Really needed?
Source: "bin\libgraphite2.dll"; DestDir: "{app}"; Flags: ignoreversion

; HarfBuzz OpenType text shaping engine
; Really needed?
Source: "bin\libharfbuzz-0.dll"; DestDir: "{app}"; Flags: ignoreversion

; LibIconv, conversions between character encodings
Source: "bin\libiconv-2.dll"; DestDir: "{app}"; Flags: ignoreversion

; ICU, International Components for Unicode
; After changes for supporting UTF-8 path and file names by using Boost Locale, all those 5
Source: "bin\libicudt??.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libicuin??.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libicuio??.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libicutu??.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libicuuc??.dll"; DestDir: "{app}"; Flags: ignoreversion

; Library for native language support, part of GNU gettext
Source: "bin\libintl-8.dll"; DestDir: "{app}"; Flags: ignoreversion

; libjpeg, C library for reading and writing JPEG image files
Source: "bin\libjpeg-8.dll"; DestDir: "{app}"; Flags: ignoreversion

; Little CMS, color management system
Source: "bin\liblcms2-2.dll"; DestDir: "{app}"; Flags: ignoreversion

; XZ Utils, LZMA compression library
Source: "bin\liblzma-5.dll"; DestDir: "{app}"; Flags: ignoreversion

; MNG / Portable Network Graphics ("animated PNG")
Source: "bin\libmng-2.dll"; DestDir: "{app}"; Flags: ignoreversion

; PCRE, Perl Compatible Regular Expressions
; "libpcre2-16-0.dll" is new for 0.12.0.0; unclear whether "libpcre16-0.dll" is still needed
Source: "bin\libpcre-1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libpcre16-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libpcre2-16-0.dll"; DestDir: "{app}"; Flags: ignoreversion

; libpng, the official PNG reference library
Source: "bin\libpng16-16.dll"; DestDir: "{app}"; Flags: ignoreversion

; libstdc++, GNU Standard C++ Library
Source: "bin\libstdc++-6.dll"; DestDir: "{app}"; Flags: ignoreversion

; LibTIFF, TIFF Library and Utilities
Source: "bin\libtiff-5.dll"; DestDir: "{app}"; Flags: ignoreversion

; C++ threading support
Source: "bin\libwinpthread-1.dll"; DestDir: "{app}"; Flags: ignoreversion

; zlib compression library
Source: "bin\zlib1.dll"; DestDir: "{app}"; Flags: ignoreversion

; Stack protection
Source: "bin\libssp-0.dll"; DestDir: "{app}"; Flags: ignoreversion

; HIDAPI, library for communicating with USB and Bluetooth devices, for hardware wallets
Source: "bin\libhidapi-0.dll"; DestDir: "{app}"; Flags: ignoreversion

; OpenSSL shared libraries
Source: "bin\libeay32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\ssleay32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libcrypto-1_1-x64.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\libssl-1_1-x64.dll"; DestDir: "{app}"; Flags: ignoreversion

; Camera support
Source: "bin\libzbar-0.dll"; DestDir: "{app}"; Flags: ignoreversion

[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:";

[Run]
Filename: "{app}\ReadMe.htm"; Description: "Show ReadMe"; Flags: postinstall shellexec skipifsilent

; DON'T offer to run the wallet right away, let the people read about initial blockchain download first in the ReadMe
; Filename: "{app}\oscillate-wallet-gui.exe"; Description: "Run GUI Wallet now"; Flags: postinstall nowait skipifsilent

[Code]
var
  BlockChainDirPage: TInputDirWizardPage;
  blockChainDefaultDir: String;

procedure InitializeWizard;
var s: String;
    width: Integer;
begin
  // Large image for the "Welcome" page, with page reconfigured
  WizardForm.WelcomeLabel1.Visible := false;
  WizardForm.WelcomeLabel2.Visible := false;
  WizardForm.WizardBitmapImage.Height := 300;
  WizardForm.WizardBitmapImage.Width := 500;

  // Image for the "Finnish" screen, in standard WizardBitmapImage size of 164 x 314
  ExtractTemporaryFile('FinishImage.bmp');
  WizardForm.WizardBitmapImage2.Bitmap.LoadFromFile(ExpandConstant('{tmp}\FinishImage.bmp'));

  // Additional wizard page for entering a special blockchain location
  blockChainDefaultDir := ExpandConstant('{commonappdata}\oscillate');
  s := 'The default folder to store the Oscillate blockchain is ' + blockChainDefaultDir;
  s := s + '. As this will need more than 50 GB of free space, you may want to use a folder on a different drive.';
  s := s + ' If yes, specify that folder here.';

  BlockChainDirPage := CreateInputDirPage(wpSelectDir,
    'Select Blockchain Directory', 'Where should the blockchain be installed?',
    s,
    False, '');
  BlockChainDirPage.Add('');

  BlockChainDirPage.Values[0] := GetPreviousData('BlockChainDir', '');
  if BlockChainDirPage.Values[0] = '' then begin
    // Unfortunately 'TInputDirWizardDirPage' does not allow empty field
    BlockChainDirPage.Values[0] := blockChainDefaultDir;
  end;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  // Store the selected folder for further reinstall/upgrade
  SetPreviousData(PreviousDataKey, 'BlockChainDir', BlockChainDirPage.Values[0]);
end;

function BlockChainDir(Param: String) : String;
// Directory of the blockchain
var s: String;
begin
  s := BlockChainDirPage.Values[0];
  Result := s;
  // No quotes for folder name with blanks as this is never used as part of a command line
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var s: String;
begin
  // Fill the 'Ready Memo' with the normal settings and the custom settings
  s := '';
  s := s + MemoDirInfo + NewLine + NewLine;

  s := s + 'Blockchain folder' + NewLine;
  s := s + Space + BlockChainDir('') + NewLine;

  Result := s;
end;

function DaemonLog(Param: String) : String;
// Full filename of the log of the daemon
begin
  Result := BlockChainDir('') + '\oscillate.log';
  // No quotes for filename with blanks as this is never used as part of a command line
end;

function DaemonFlags(Param: String): String;
// Flags to add to the shortcut to the daemon
var s: String;
begin
  s := BlockChainDir('');
  if s = blockChainDefaultDir then begin
    // No need to add the default dir as flags for the daemon
    s := '';
  end;
  if Pos(' ', s) > 0 then begin
    // Quotes needed for filename with blanks
    s := '"' + s + '"';
  end;
  if s <> '' then begin
    s := '--data-dir ' + s;
  end;
  Result := s;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var s: TArrayOfString;
begin
  if CurStep = ssPostInstall then begin
    // Re-build "oscillate-daemon.bat" according to actual install and blockchain directory used
    SetArrayLength(s, 3);
    s[0] := 'REM Execute the Oscillate daemon and then stay with window open after it exits';
    s[1] := '"' + ExpandConstant('{app}\oscillated.exe') + '" ' + DaemonFlags('');
    s[2] := 'PAUSE';
    SaveStringsToFile(ExpandConstant('{app}\oscillate-daemon.bat'), s, false);
  end;
end;

function InitializeUninstall(): Boolean;
var s: String;
begin
  s := 'Please note: Uninstall will not delete any downloaded blockchain. ';
  s := s + 'If you do not need it anymore you have to delete it manually.';
  s := s + #13#10#13#10 + 'Uninstall will not delete any wallets that you created either.';
  MsgBox(s, mbInformation, MB_OK);
  Result := true;
end;


[Icons]
; Icons in the "Oscillate GUI Wallet" program group
; Windows will almost always display icons in alphabetical order, per level, so specify the text accordingly
Name: "{group}\Oscillate GUI Wallet"; Filename: "{app}\oscillate-wallet-gui.exe"
Name: "{group}\Uninstall Oscillate GUI Wallet"; Filename: "{uninstallexe}"

; Sub-folder "Utilities";
; Note that Windows 10, unlike Windows 7, ignores such sub-folders completely
; and insists on displaying ALL icons on one single level
Name: "{group}\Utilities\Oscillate Daemon"; Filename: "{app}\oscillated.exe"; Parameters: {code:DaemonFlags}
Name: "{group}\Utilities\Read Me"; Filename: "{app}\ReadMe.htm"

; CLI wallet: Needs a working directory ("Start in:") set in the icon, because with no such directory set
; it tries to create new wallets without a path given in the probably non-writable program folder and will abort with an error
Name: "{group}\Utilities\Textual (CLI) Wallet"; Filename: "{app}\oscillate-wallet-cli.exe"; WorkingDir: "{userdocs}\Oscillate\wallets"

; Icons for troubleshooting problems / testing / debugging
; To show that they are in some way different (not for everyday use), make them visually different
; from the others by text, and make them sort at the end by the help of "x" in front
Name: "{group}\Utilities\x (Check Blockchain Folder)"; Filename: "{win}\Explorer.exe"; Parameters: {code:BlockChainDir}
Name: "{group}\Utilities\x (Check Daemon Log)"; Filename: "Notepad"; Parameters: {code:DaemonLog}
Name: "{group}\Utilities\x (Check Default Wallet Folder)"; Filename: "{win}\Explorer.exe"; Parameters: "{userdocs}\Oscillate\wallets"
Name: "{group}\Utilities\x (Check GUI Wallet Log)"; Filename: "Notepad"; Parameters: "{app}\oscillate-wallet-gui.log"
Name: "{group}\Utilities\x (Try Daemon, Exit Confirm)"; Filename: "{app}\oscillate-daemon.bat"
Name: "{group}\Utilities\x (Try GUI Wallet Low Graphics Mode)"; Filename: "{app}\start-low-graphics-mode.bat"
Name: "{group}\Utilities\x (Try Kill Daemon)"; Filename: "Taskkill.exe"; Parameters: "/IM oscillated.exe /T /F"

; Desktop icons, optional with the help of the "Task" section
Name: "{userdesktop}\Oscillate GUI Wallet"; Filename: "{app}\oscillate-wallet-gui.exe"; Tasks: desktopicon


[Registry]
; Store any special flags for the daemon in the registry location where the GUI wallet will take it from
; So if the wallet is used to start the daemon instead of the separate icon the wallet will pass the correct flags
; Side effect, mostly positive: The uninstaller will clean the registry
Root: HKCU; Subkey: "Software\oscillate"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\oscillate\oscillate"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\oscillate\oscillate"; ValueType: string; ValueName: "daemonFlags"; ValueData: {code:DaemonFlags};
