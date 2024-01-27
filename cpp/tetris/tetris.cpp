#include<iostream>
#include<Windows.h>
#include<thread>
#include<vector>
using namespace std;

wstring tetromino[7];
//playing field dimentions : from GameBoy
int nFieldWidth = 12;
int nFieldHeight = 18;

// not statically allocated --> allocate dynamically 
unsigned char* pField = nullptr; 
// unsigned char : 0-> empty space; 9 have walls info

// console screen 
//default size of terminal in windows 11 is 120*30; can chage it from terminal settings--> startup --> size
int nScreenWidth = 120; // screen size X -- columns 
int nScreenHeight = 30; // screen size Y -- rows

int Rotate(int px, int py, int r) {
	int w = 4; // width is the length of strings "..X." i.e 4
	switch (r % 4) {
		// normal -> 0 deg
		case 0 : return (py * w) + px;

		// 90 deg rotate
		case 1: return 12 + py - (px * w);

		// 180 deg rotate
		case 2: return 15 - px - (py * w);

		// 270 deg rotate
		case 3: return 3 - py + (px * w);

	}
	return 0;

}

bool DoesPieceFit(int nTetromino, int nRotation, int nPosX, int nPosY) {

	for (int px = 0; px < 4; px++) {
		for (int py = 0; py < 4; py++) {
			// get index into piece
			int pi = Rotate(px, py, nRotation);
		
			// get index into field
			int fi = (nPosY + py) * nFieldWidth + (nPosX + px);
		
			if (nPosX + px >= 0 && nPosX + px < nFieldWidth) {
				if (nPosY + py >= 0 && nPosY + py < nFieldHeight) {

					if (tetromino[nTetromino][pi] == L'X' && pField[fi] != 0)
						return false; // fails when tetromino hits something
				}
			}
		}
	}

	return true;
}


int main() {
	// create assets --> 7 shapes
	tetromino[0].append(L"..X.");
	tetromino[0].append(L"..X.");
	tetromino[0].append(L"..X.");
	tetromino[0].append(L"..X.");


	tetromino[1].append(L"..X.");
	tetromino[1].append(L".XX.");
	tetromino[1].append(L".X..");
	tetromino[1].append(L"....");


	tetromino[2].append(L".X..");
	tetromino[2].append(L".XX.");
	tetromino[2].append(L"..X.");
	tetromino[2].append(L"....");


	tetromino[3].append(L"....");
	tetromino[3].append(L".XX.");
	tetromino[3].append(L".XX.");
	tetromino[3].append(L"....");


	tetromino[4].append(L"..X.");
	tetromino[4].append(L".XX.");
	tetromino[4].append(L"..X.");
	tetromino[4].append(L"....");


	tetromino[5].append(L"....");
	tetromino[5].append(L".XX.");
	tetromino[5].append(L"..X.");
	tetromino[5].append(L"..X.");


	tetromino[6].append(L"....");
	tetromino[6].append(L".XX.");
	tetromino[6].append(L".X..");
	tetromino[6].append(L".X..");


	wchar_t* screen = new wchar_t[nScreenWidth * nScreenHeight];
	for (int i = 0; i < nScreenWidth * nScreenHeight; i++) { screen[i] = L' '; }
	HANDLE hConsole = CreateConsoleScreenBuffer(GENERIC_READ | GENERIC_WRITE, 0, NULL, CONSOLE_TEXTMODE_BUFFER, NULL);
	SetConsoleActiveScreenBuffer(hConsole);
	DWORD dwBytesWritten = 0;

	// create play field 
	pField = new unsigned char[nFieldHeight * nFieldWidth];
	for (int x = 0; x < nFieldWidth; x++) {// border boundry
		for (int y = 0; y < nFieldHeight; y++) {
			pField[(y * nFieldWidth) + x] = (x == 0 || x == (nFieldWidth - 1) || y == (nFieldHeight - 1)) ? 9 : 0;
		}
	}


	// Game Logic parameters	
	bool bGameOver = false;
	int nCurrentPiece = 1;
	int nCurrentRotation = 0;
	int nCurrentX = nFieldWidth / 2;
	int nCurrentY = 0;
	bool bKey[4];
	bool bRotateHold = false;
	
	int nSpeed = 20;
	int nSpeedCounter = 0;
	bool bForceDown = false;
	int nPieceCount = 0;
	int nScore = 0;

	vector<int> vLines;

	while (!bGameOver)
	{
		// GAME TIMING ====================================================
		this_thread::sleep_for(50ms);
		nSpeedCounter++;
		bForceDown = (nSpeedCounter == nSpeed);

		// USER INPUT ====================================================
		// if key is pressed the below statement returns true
		// Right arrow:\x27 Left: \x25 Down:\x28 are virtual key codes 
		for (int k = 0; k < 4; k++) {							 // R   L   D Z // R: Right L:Left D: Down and Z key(to rotate) 
			bKey[k] = (0x8000 & GetAsyncKeyState((unsigned char)("\x27\x25\x28Z"[k]))) != 0;
		}

		// GAME LOGIC =====================================================

		// Check to right
		nCurrentX += (bKey[0] && DoesPieceFit(nCurrentPiece, nCurrentRotation, nCurrentX + 1, nCurrentY)) ? 1 : 0;

		//Check to left
		nCurrentX -= (bKey[1] && DoesPieceFit(nCurrentPiece, nCurrentRotation, nCurrentX - 1, nCurrentY)) ? 1 : 0;

		// check down
		nCurrentY += (bKey[2] && DoesPieceFit(nCurrentPiece, nCurrentRotation, nCurrentX, nCurrentY + 1)) ? 1 : 0;

		// handle rotation	

		if (bKey[3]) {
			nCurrentRotation += (!bRotateHold && DoesPieceFit(nCurrentPiece, nCurrentRotation + 1, nCurrentX, nCurrentY)) ? 1 : 0;
			bRotateHold = true;
		}
		else
			bRotateHold = false;


		if (bForceDown)
		{
			if (DoesPieceFit(nCurrentPiece, nCurrentRotation, nCurrentX, nCurrentY + 1))
				nCurrentY++; // it can do it
			else
			{
				// lock the piece as it can't drop down; 
				// make it background
				for (int px = 0; px < 4; px++)
					for (int py = 0; py < 4; py++)
						if (tetromino[nCurrentPiece][Rotate(px, py, nCurrentRotation)] == L'X')
							pField[(nCurrentY + py) * nFieldWidth + (nCurrentX + px)] = nCurrentPiece + 1;
				
				nPieceCount++;
				if (nPieceCount % 10 == 0)
					if (nSpeed >= 10) nSpeed--;

				//  check for lines
				for (int py = 0; py < 4; py++)
					if (nCurrentY + py < nFieldHeight - 1)
					{
						bool bLine = true;
						for (int px = 1; px < nFieldWidth - 1; px++)
							bLine &= (pField[(nCurrentY + py) * nFieldWidth + px]) != 0;

						if (bLine) {
							// remove line; set to =
							for (int px = 1; px < nFieldWidth - 1; px++)
								pField[(nCurrentY + py) * nFieldWidth + px] = 8;

							vLines.push_back(nCurrentY + py);
						}
					}

				nScore += 25;
				if (!vLines.empty()) nScore += (1 << vLines.size()) * 100;

				//choose next piece
				nCurrentX = nFieldWidth / 2;
				nCurrentY = 0;
				nCurrentRotation = 0;
				nCurrentPiece = rand() % 7;

				// if piece does not fit

				bGameOver = !DoesPieceFit(nCurrentPiece, nCurrentRotation, nCurrentX, nCurrentY);
			}

			nSpeedCounter = 0;
		}
		// RENDER OUTPUT ===================================================


		//Draw Field
		for (int x = 0; x < nFieldWidth; x++) {
			for (int y = 0; y < nFieldHeight; y++)
			{
				screen[(y + 2) * nScreenWidth + (x + 2)] = L" ABCDEFG=#"[pField[(y * nFieldWidth) + x]];
			}
		}

		//Draw Current Piece
		for (int px = 0; px < 4; px++) {
			for (int py = 0; py < 4; py++) {
				if (tetromino[nCurrentPiece][Rotate(px, py, nCurrentRotation)] == L'X') {
					screen[(nCurrentY + py + 2) * nScreenWidth + (nCurrentX + px + 2)] = nCurrentPiece + 65;
					// +65='A'; converts piece to ASCII letter 
				}
			}
		}

		swprintf_s(&screen[ nScreenWidth + nFieldWidth + 6], 16, L"SCORE: %8d", nScore);

		if (!vLines.empty()) {

			//Display Frame:
			//  use hConsole --> draw screen --> dim width*height --> start from 0,0 --> 
			WriteConsoleOutputCharacter(hConsole, screen, nScreenWidth * nScreenHeight, { 0,0 }, &dwBytesWritten);
			this_thread::sleep_for(400ms);

			for(auto &v:vLines)
				for (int px = 1; px < nFieldWidth - 1; px++)
				{
					for (int py = v; py > 0; py--)
						pField[py * nFieldWidth + px] = pField[(py - 1) * nFieldWidth + px];
					pField[px] = 0;
				}
			vLines.clear();
		}
		// display frame
		WriteConsoleOutputCharacter(hConsole, screen, nScreenWidth * nScreenHeight, { 0,0 }, &dwBytesWritten);
	}
	//game over
	CloseHandle(hConsole);
	cout << "GAME OVER!! Score:" << nScore << endl;
	system("pause");


	return 0;
}