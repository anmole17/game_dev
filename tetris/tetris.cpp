#include <iostream>
using namespace std;

wstring tetromino[7];
//playing field dimentions : from GameBoy
int nFieldWidth = 12;
int nFieldHeight = 18;

// not statically allocated --> allocate dynamically 
unsigned char* pField = nullptr; 
// unsigned char : 0-> empty space; 9 have walls info

// console screen 
int nScreenWidth = 80; // screen size X -- columns
int nScreenHeight = 30; // screen size Y -- rows

int Rotate(int px, int py, int r) {

	switch (r % 4) {
		// normal -> 0 deg
		case 0 : return py * 4 + px;

		// 90 deg rotate
		case 1: return 12 + py - (px * 4);

		// 180 deg rotate
		case 2: return 15 - px - (py * 4);

		// 270 deg rotate
		case 3: return 3 + py + (px * 4);

	}
	return 0;

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
	
	// create play field 
	pField = new unsigned char[nFieldHeight * nFieldWidth];
	for (int x = 0; x < nFieldWidth; x++) {// border boundry
		for (int y = 0; y < nFieldHeight; y++) {
			pField[y * nFieldWidth + x] = (x == 0 || x == nFieldWidth - 1 || y == nFieldHeight - 1) ? 9 : 0;
		}
	}
	wchar_t* screen = new wchar_t[nScreenWidth * nScreenHeight];
	for (int i = 0; i < nScreenWidth * nScreenHeight; i++) screen[i] = L' ';
	HANDLE hConsole = CreateConsoleScreenBuffer(GENERIC_READ | GENERIC_WRITE, 0, NULL, CONSOLE_TEXTMODE_BUFFER, NULL);
	SetConsileActiveScreenBuffer(hConsole);
	DWORD dwBytesWritten = 0;

	
	bool bGameOver = false;
	while (!bGameOver)
	{


		// //Display Frame: use hConsole --> draw screen --> dim width*height --> start from 0,0 --> 
		WriteConsoleOutputCharacter(hConsole, screen, nScreenWidth * nScreenHeight, { 0.0 }, &dwBytesWritten);

	}



	return 0;
}