#ifndef RUNNER_APP_IDENTITY_H_
#define RUNNER_APP_IDENTITY_H_

// Identify KRYPT AUDIO consistently in the Windows shell.
inline constexpr wchar_t kKryptAudioAppId[] = L"com.synapselabs.kryptaudio";

// Register the shell identity before creating any windows.
void ConfigureAppIdentity();

#endif  // RUNNER_APP_IDENTITY_H_
