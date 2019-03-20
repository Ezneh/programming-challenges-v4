module rot13;

import std.stdio;
import std.ascii;
import std.string : indexOf;
int main(string[] args)
{

    if (args.length < 2 )
    {
        // the user has to provide a string enclosed in " in order for it to be fully processed.
        writeln("Usage: rot13 \"<string>\"");
        return -1;
    }

    foreach(c; args[1])
    {
        if (c.isAlpha)
        {
            if(c.isUpper)
                putchar(uppercase[(uppercase.indexOf(c) + 13) % 26]);
            else
                putchar(lowercase[(lowercase.indexOf(c) + 13) % 26]);
        }
        else
        {
            putchar(c);
        }
    }
    return 0;
}