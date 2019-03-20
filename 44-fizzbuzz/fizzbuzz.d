module fizzbuzz;

import std.stdio;
import std.conv;

int main(string[] args)
{
    // user input will come from command line arguments

    if (args.length < 2)
    {
        writeln("Usage: fizzbuzz number1 [...]");
        return -1;
    }

    foreach(arg; args[1..$])
    {
        try
        {
            scope(failure) writefln("Could not parse %s", arg);
            auto i = parse!long(arg);

            string result;

            if (i % 3 == 0) result ~= "Fizz";
            if (i % 5 == 0) result ~= "Buzz";

            writefln("%d: %s", i, result);
        }
        catch (Exception e) { }
    }

    return 0;
}