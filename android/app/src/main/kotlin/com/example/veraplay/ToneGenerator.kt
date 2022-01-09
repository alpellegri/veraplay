package com.example.veraplay

import android.util.Log

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;

import kotlin.math.*

class ToneGenerator {
    // Kotlin does not allow properties and variables of a class to be uninitialized
    // So use lateinit keyword to initialize the variables later on
    lateinit var Track: AudioTrack
    var isPlaying: Boolean = false
    val Fs: Int = 44100
    val buffLength: Int = AudioTrack.getMinBufferSize(
        Fs, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT)
    var frequency: Int = 440
    val frame_out: ShortArray = ShortArray(buffLength)
    var phase: Double = 0.0

    fun initTrack() {
        Log.v("TAG", "initTrack")

        // AudioTrack is deprecated for some android versions
        // Please look up for other alternatives if this does not work
        Track = AudioTrack(
            AudioManager.MODE_NORMAL, Fs, AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT, buffLength, AudioTrack.MODE_STREAM
        )
    }

    fun setFrequency(f: Int) : Int {
        Log.v("TAG", "setFrequency: " + f.toString())
        frequency = f
        return 0
    }

    fun playback() {
        // simple sine wave generator
        val amplitude: Int = 32767
        val k: Double = 2*PI*frequency/Fs
        if (isPlaying) {
            for (i in 0 until buffLength) {
                phase += k
                frame_out[i] = (amplitude * Math.sin(phase)).toInt().toShort()
            }
            Track.write(frame_out, 0, buffLength)
        }
    }

    fun startPlaying() {
        Log.v("TAG", "startPlaying: " + isPlaying.toString())
        Track.play()
        isPlaying = true
    }

    fun stopPlaying() {
        Log.v("TAG", "stopPlaying: " + isPlaying.toString())
        if (isPlaying) {
            isPlaying = false
            // Stop playing the audio data and release the resources
            Track.stop()
            Track.release()
        }
    }
}
