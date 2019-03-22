module hanoi;

import std.conv;
import std.stdio;
import std.string : center;

import arsd.terminal;

// A = start, B = inter, C = end
enum T { A, B, C }

// global variables are shit, but since it's a simple 1-use program, who the fuck cares
T[] disks;  // this array tells on which tower is each disk (rework it ?)
int[3] disks_per_tower; // saves the number of disks per tower (to find what is the top row for each disk in the tower)
int number_of_disks;
string empty_disk;
string[] disks_text;

int main(string[] args)
{
    if (args.length < 2)
    {
        writeln("Usage: hanoi number_of_disks");
        return -1;
    }


    scope(failure) writeln("number_of_disks should be a positive number");
    number_of_disks = parse!int(args[1]);

    auto terminal = Terminal(ConsoleOutputType.cellular);
    terminal.hideCursor();

    // only allow a maximum of 10 disks (otherwise the console won't properly show them)
    if (number_of_disks < 2 || number_of_disks > 10)
    {
        writeln("The number of disks should be between 2 and 10.");
        return -2;
    }

    disks = new T[](number_of_disks);
    disks_text = new string[](number_of_disks);
    disks_per_tower[0] = number_of_disks;

    init_disks_text();
    terminal.init_towers();
    
    // n-1 because n disks from 0 to n-1
    hanoi(terminal, number_of_disks-1, T.A, T.C, T.B);
    auto input = RealTimeConsoleInput(&terminal, ConsoleInputFlags.raw);
    auto ch = input.getch();
    return 0;
}

void hanoi(ref Terminal terminal, int n, T src, T dest, T inter)
{
    if (n >= 0)
    {
        hanoi(terminal, n-1, src, inter, dest);
        // moved in draw_step because it breaks everything ?
        //disks[n] = dest; 
        terminal.draw_step(n, src, dest);
        hanoi(terminal, n-1, inter, dest, src);
    }
}

void init_disks_text()
{
    empty_disk = center("|", (number_of_disks * 2) + 3, ' ');
    for (int d; d < number_of_disks; ++d)
    {
        auto disk_size = d * 2;
        auto disk = center("▐" ~ center("█", disk_size + 1, '█') ~ "▌", (number_of_disks * 2) + 3, ' ');
        disks_text[d] = disk;
    }
}

// should draw disks on first tower
void init_towers(ref Terminal terminal)
{
    // draws first tower (all disks);
    terminal.draw_disks();

    // draws 2nd and 3rd towers
    auto second_tower_start = 4 + (number_of_disks * 2);
    for (int i; i < number_of_disks; ++i)
    {
        terminal.moveTo(second_tower_start, i);
        terminal.writef("  %s  %s ", empty_disk, empty_disk);
    }
    terminal.flush();
}

// this function is called once at the start of the program (initiating disks on the terminal)
void draw_disks(ref Terminal terminal)
{
    for (int d; d < number_of_disks; ++d)
    {
        terminal.draw_disk(d, d, 0);
    }
}

void draw_disk(ref Terminal terminal, int d, int row, int tower)
{
    auto column = tower * ((number_of_disks * 2) + 5);
    terminal.moveTo(column, row, ForceOption.alwaysSend);
    terminal.writef(" %s ", disks_text[d]);
    terminal.flush();
}

void reset_tower_row(ref Terminal terminal, int line, int tower)
{
    auto column = tower * ((number_of_disks * 2) + 5);
    terminal.moveTo(column, line, ForceOption.alwaysSend);
    terminal.writef(" %s ", empty_disk);
    terminal.flush();
}

void draw_step(ref Terminal terminal, int d, T src, T dest)
{
    import std.algorithm : countUntil;
    import core.thread;

    Thread.sleep(dur!("msecs")(100));
    auto lowest_disk = disks.countUntil(src);

    // reset row on src
    auto old_row = number_of_disks - disks_per_tower[src];
    terminal.reset_tower_row(old_row, src);
    --disks_per_tower[src];

    // draw disk on dest
    ++disks_per_tower[dest];
    auto new_row = number_of_disks - disks_per_tower[dest];
    terminal.draw_disk(lowest_disk, new_row, dest);
    disks[d] = dest;
}