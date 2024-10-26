# BDiff / BPatch Tests

This directory contains a set of tests of _BDiff_ and _BPatch_. They are run by calling `Test.bat` with various command line parameters.

## Requirements

1. `Test.bat` must be run from a command line console which has its current directory set to the directory that contains `Test.bat`.

2. The `BDIFFPATH` environment variable must be set to the directory containing both `BDiff.exe` and `BPatch.exe`. `Test.bat` uses this environment variable to find the correct versions of the programs to test. 

    `Test.bat` will stop with an error if `BDIFFPATH` is not set or if either of `BDiff.exe` or `BPatch.exe` is not in the directory stored in `BDIFFPATH`.

3. Files named `Test1`, `Test2`, `Test1_Large` and `Test2_Large` are provided. They must be located in the same directory as `Test.bat`.

    `Test1` and `Test2` are different versions of the same file and are both smaller than 64KiB. ***They must not be modified***.
    
    `Test1_Large` and `Test2_Large` are different versions of the same file and are larger than 128KiB. These files _may_ be modified, but must remain different to each other and both must be larger than 128KiB.

4. Files named `Diff-b`, `Diff-f` and `Diff-q`are provided. They must be in the same directory as `Test.bat` and ***must not be modified***. These files are used to check for the expected output from `test patch`, `test quoted` and `test filtered`, respectively. The tests will fail if these files or `Test1` or `Test2` have been modified.

## Tests

### Patching tests

#### Small file test

Run the test by entering the command: 

    Test patch
    
BDiff is run on `Test1` and `Test2` and creates a binary diff file named `Patch`. BPatch then applies `Patch` to `Test1` to create `Test3`, which should be identical to `Test2`. The Windows FC command is used to verify that `Test2` and `Test3` are in fact the same and that `Patch` is as expected (it must be the same as `Diff-p`).

#### Large file test

Run the test by entering the command: 

    Test patch large
    
BDiff is run on `Test1_Large` and `Test2_Large` and creates a binary diff file named `Patch_Large`. BPatch then applies `Patch_Large` to `Test1_Large` to create `Test3_Large`, which should be identical to `Test2_Large`. The Windows FC command is used to verify that `Test2_Large` and `Test3_Large` are in fact the same. There is no check that `Patch_Large` is as expected.

### Quoted format diff test

Run the test by entering the command: 

    Test quoted

or

    Test quoted view
    
BDiff is run on `Test1` and `Test2` and creates a quoted text diff file named `Diff` that is compared against the expected content in `Diff-q`. If the optional `view` parameter is provided `Diff` is displayed in NotePad.

### Filtered format diff test

Run the test by entering the command: 

    Test filtered
    
or

    Test filtered view

BDiff is run on `Test1` and `Test2` and creates a filtered text diff file named `Diff` that is compared against the expected content in `Diff-f`. If the optional `view` parameter is provided `Diff` is displayed in NotePad.

### Version test

Run the test by entering the command: 

    Test version
    
Both BDiff and BPatch are called with the `--version` option and both output their current version on the console. You should check that they report the expected version numbers.

### Help test

Run the test by entering the command: 

    Test help

Both BDiff and BPatch are called with the `--help` option and both output their help screen on the console.

### Clean up

To delete all the temporary files that were generated when running tests enter the command:

    Test clean

## Helper scripts

The most common use case for `Test.bat` is to test the programs that have just been compiled. For this reason two helper script files are provided. They are:

1. `Test32.bat`
2. `Test64.bat`

These files set the `%BDIFFPATH%` environment variable to the directories where the compiler outputs the 32 bit and 64 bit Windows executables, respectively. Both scripts then call `Test.bat`, passing along all parameters.

For these scripts to work, the `Test` directory must have the same parent directory as the `_build` directory that is created by the compiler.

## Examples

### Example 1

Suppose the versions of BDiff and BPatch to be tested are in `C:\Utils` and you want to:

1. check the version of the programs
2. perform the Patch test
3. clear up the generated files.

Assume that `Test.bat` is stored in `D:\BDiff\Test`.

Open a command console then enter the following commands. In the following, items preceded by `>` are the commands you type and any following text represents the output (your output may vary).

    >cd C:\BDiff\Test
    
    >D:
    
    >set BDIFFPATH=C:\Utils
   
    >Test version
    bdiff-1.0.0-rc.1 2024-10-24 (Windows 64 bit)
    bpatch-1.0.0-rc.1 2024-10-24 (Windows 64 bit)
    Done
    
    >Test patch
    --- Creating binary Patch with bdiff ---
    BDiff.exe: loading old file
    BDiff.exe: loading new file
    BDiff.exe: block sorting old file
    BDiff.exe: generating patch
    BDiff.exe: done

    --- Testing Patch against expected Diff-b with fc ---
    Comparing files Patch and DIFF-B
    FC: no differences encountered

    --- Applying binary Patch with bpatch ---

    --- Testing restored Test3 file against original with fc ---
    Comparing files Test2 and TEST3
    FC: no differences encountered


    Done

    >Test clean
    Done

### Example 2

Assume that `Test.bat` and `Test64.bat` are both in `D:\BDiff\Test` and that Delphi has compiled the 64 bit of the programs into `D:\BDiff\_build\Win64\exe`. You can test recently built 64 bit versions of the programs with the following:

    >cd C:\BDiff\Test
    
    >D:

    >Test64 version
    bdiff-1.0.0-rc.1 2024-10-24 (Windows 64 bit)
    bpatch-1.0.0-rc.1 2024-10-24 (Windows 64 bit)
    Done

    >Test64 patch
    << output omitted: same as example 1 >>

    >Test64 clean
    Done

### Example 3

Assume that `Test.bat` and `Test32.bat` are both in `D:\BDiff\Test` and that Delphi has compiled the 64 bit of the programs into `D:\BDiff\_build\Win32\exe`. You can test recently built 64 bit versions of the programs with the following:

    >cd C:\BDiff\Test
    
    >D:

    >Test32 version
    bdiff-1.0.0-rc.1 2024-10-24 (Windows 32 bit)
    bpatch-1.0.0-rc.1 2024-10-24 (Windows 32 bit)
    Done

    >Test32 patch
    << output omitted: same as example 1 >>

    >Test32 clean
    Done
