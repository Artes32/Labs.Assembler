#include "stdafx.h"
#include "Laba7.h"
#include <windows.h> 
#define BALL                            102

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
void Draw(HDC hDC, int x, int y);

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrevInst, LPSTR lpCmdLine, int nCmdShow)
{
	TCHAR szClassName[] = L"Мой класс";
	HWND hMainWnd;
	MSG msg;
	WNDCLASSEX wc;
	wc.cbSize = sizeof(wc);
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc = WndProc;
	wc.lpszMenuName = NULL;
	wc.lpszClassName = szClassName;
	wc.cbWndExtra = NULL;
	wc.cbClsExtra = NULL;
	wc.hIcon = LoadIcon(NULL, IDI_WINLOGO);
	wc.hIconSm = LoadIcon(NULL, IDI_WINLOGO);
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
	wc.hInstance = hInst;
	if (!RegisterClassEx(&wc)) {
		MessageBox(NULL, L"Не получилось зарегистрировать класс!", L"Ошибка", MB_OK);
		return NULL;
	}
	hMainWnd = CreateWindow(
		szClassName,
		L"Движущаяся новогодняя ёлка",
		WS_OVERLAPPEDWINDOW | WS_VSCROLL,
		CW_USEDEFAULT,
		NULL,
		CW_USEDEFAULT,
		NULL,
		(HWND)NULL,
		NULL,
		HINSTANCE(hInst),
		NULL);
	if (!hMainWnd) {
		MessageBox(NULL, L"Не получилось создать окно!", L"Ошибка", MB_OK);
		return NULL;
	}
	ShowWindow(hMainWnd, nCmdShow);
	UpdateWindow(hMainWnd);
	while (GetMessage(&msg, NULL, NULL, NULL)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	return msg.wParam;
}

int i = 0, x, y, c, d, t = 0, dx, dy, check = 0;
const int RL = 68, Btm = 107, Top = 128;
LRESULT CALLBACK WndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {

	HDC hDC = GetDC(hWnd);
	RECT rect;
	static HWND button;
	static int _width, _height;

	switch (uMsg) {

	case WM_SIZE:
	{
		_width = LOWORD(lParam);
		_height = HIWORD(lParam);
		break;
	}

	case WM_COMMAND:
	{
		if (LOWORD(wParam) == 1)
		{
			KillTimer(NULL, -1);
			i = 0;
			t = 0;
			rect = { 0 };
			rect.bottom = _height;
			rect.right = _width;
			InvalidateRect(hWnd, &rect, true);
			UpdateWindow(hWnd);
		}
		break;
	}
	break;

	case WM_TIMER:
	{
		if (check == 0)
		{
			x += dx; y += dy;
			RECT rc; GetClientRect(hWnd, &rc);
			if (x > rc.right - RL)dx = -abs(dx);
			if (x < RL)dx = abs(dx);
			if (y > rc.bottom - Btm)dy = -abs(dy);
			if (y < Top)dy = abs(dy);
			InvalidateRect(hWnd, NULL, TRUE);
		}
		break;
	}

	case WM_PAINT:
	{
		if (t == 0) break;
		if (t > 0) {
			PAINTSTRUCT ps;
			HDC hdc = BeginPaint(hWnd, &ps);
			HPEN hPen;
			COLORREF color = RGB(0, 150, 0);
			hPen = CreatePen(PS_SOLID, 4, color);
			SelectObject(hDC, hPen);
			MoveToEx(hDC, x, y + 14, NULL);
			LineTo(hDC, x - 68, y + 107);
			LineTo(hDC, x + 68, y + 107);
			LineTo(hDC, x, y + 14);
			MoveToEx(hDC, x, y - 68, NULL);
			LineTo(hDC, x - 55, y + 12);
			LineTo(hDC, x + 55, y + 12);
			LineTo(hDC, x, y - 68);
			MoveToEx(hDC, x, y - 128, NULL);
			LineTo(hDC, x - 40, y - 68);
			LineTo(hDC, x + 40, y - 68);
			LineTo(hDC, x, y - 128);
			EndPaint(hWnd, &ps);
			break;
		}
	}

	case WM_LBUTTONUP:
	{
		if (i == 1) {
			x = c; y = d;
			dx = 2; dy = -2;
			SetTimer(hWnd, 1, 20, NULL);
			i++;
			t++;
		}
		if (i == 0) {
			c = LOWORD(lParam);
			d = HIWORD(lParam);
			Draw(hDC, c, d);
			i++;
		}
		break;

	case WM_CREATE:
	{
		button = CreateWindow(L"button", L"Clear", WS_CHILD | WS_VISIBLE, _width / 2, _height / 2, 80, 40, hWnd, (HMENU)1, ((LPCREATESTRUCT)lParam)->hInstance, NULL);
		break;
	}

	case WM_DESTROY:
		PostQuitMessage(NULL);
		break;


	default:
		return DefWindowProc(hWnd, uMsg, wParam, lParam);
	}
	return NULL;
	}
}

void Draw(HDC hDC, int x, int y) {
	HPEN hPen;
	COLORREF color = RGB(0, 150, 0);

	hPen = CreatePen(PS_SOLID, 4, color);
	SelectObject(hDC, hPen);
	MoveToEx(hDC, x, y + 14, NULL);
	LineTo(hDC, x - 68, y + 107);
	LineTo(hDC, x + 68, y + 107);
	LineTo(hDC, x, y + 14);
	MoveToEx(hDC, x, y - 68, NULL);
	LineTo(hDC, x - 55, y + 12);
	LineTo(hDC, x + 55, y + 12);
	LineTo(hDC, x, y - 68);
	MoveToEx(hDC, x, y - 128, NULL);
	LineTo(hDC, x - 40, y - 68);
	LineTo(hDC, x + 40, y - 68);
	LineTo(hDC, x, y - 128);
}