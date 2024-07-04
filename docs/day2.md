# 7 days of GB dev - Day 2

Welcome to day 2. I recommend reading day 1 first.

## What was THE PLAN

This day I wanted to get audio working, most specifically I wanted to hear music. And guess who went down a rabbithole! It was I!

Finding sheet music of the tetris tune is not difficult. But then I ran into the next issue, while I can read sheet music, manually translating it to notes to play on the gameboy
would have been a lot of manual work. So I spend some time to figure out how to handle this, and finally managed to snag a good midi file of the tetris tune, and use https://mido.readthedocs.io/ to extract the notes and timing.

I only extracted at which point of time to play which note, and put that in a long list. Ignoring the length of each note. I had some trouble with notes that play at the same time,
so I needed to use 3 channels to make everything work.

After that, I grabbed a note to frequency table from the internet, and with some macro magic. I convert a frequency to a period number for the audio registers.
The formula was a simple `2048-(131072 / Hz) = period_value`, but I multiply the Hz and 131072 by 100 to prevent rounding errors, as all numbers in rgbds are integers.

With some assembly code to step trough this list every 5 frames, and then putting the frequency on the right registers for the audio.
And, after some issues with other registers needing be set correct, like the length registers, voilla, we had music for channel 1 and 2.

And to my surprise, for such a hacked together thing, it did not even sound half bad.

## Channel 3

Now, the track actually is using 3 channels of music. Two main channels for the tune and a third one for sort of a bass line. I figured I could put the baseline on channel 3, the wave channel.
By putting in a square wave, it should result in a channel that is mostly the same as channel 1 and 2.

Problem there is, the frequency of channel 3 is different. Given the same `period_value`, the wave channel is at half the frequency compared to channel 1 and channel 2.

I applied an extremely simple fix. I set the wave data to `FF FF FF FF 00 00 00 00 FF FF FF FF 00 00 00 00`, which effectively doubles the frequency. And that sounded correct.

Except for one point, some low notes sound extremely high, painfully high.

Reason: These notes are so low in frequency that the calculations for the period_value are underflowing, giving a very high frequency instead of very low. For now, I added some simple clamping. Which sounds ok for now. But, a better solution would be to shift all these notes up one octave and change the wave data.

## Result

I'm happy with the result, I had never done anything with the sound hardware before, except for some quick tests. There is a lot of potential improvement here:

* Notes should have different length. For this tune it is not a huge issue, as the notes keep overwritting each other most of the time. But experienced listeners will know things are off.
* Sound effects should temporary be able to claim a channel.
* Encoding could be more compact. The fixed size blocks at a fixed rate are easy to implement, but at the same time leave a lot to be desired.

## Up next

Now that I have some music. I want blocks. My goal for the next day will be to have some falling block that can be moved and rotated.
