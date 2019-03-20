module occurrences;

import std.stdio;

int main(string[] args)
{
    // since unicode characters should be supported, then we'll use a file as the input
    // we also will allow the user to input multiple strings
    // we write the result in a file because unicode characters are not supported on the Windows Console
    auto output = File("output.txt", "w+");

    foreach(uint i, wstring line; lines(File("input.txt")))
    {
        uint[wchar] counts;
        foreach(wchar w; line)
        {
            ++counts[w];
        }

        output.writefln("%d: %s", i, counts);
    }

    return 0;
}