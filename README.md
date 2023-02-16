# De-bloat-Win10
Skrypt do usuwania denerwujących i niepotrzebnych składników Win10, oraz blokowania telemetrii

Skrypt należy uruchamiać z podwyższonymi uprawnieniami (jako administrator).

W skrypcie są wyremowane niektóre sekcje, takie jak :
- wyłączenie usługi SysMain, która w teorii analizuje i przyspiesza działanie systemu przez ciągłę trzymanie w pamięci aplikacji, które najczęściej uruchamiamy. Domyślnie skrypt jej nie wyłącza, ponieważ przy dysku SSD i dość dużej ilości RAM nie ma to większego znaczenia.
- wyłączenie zadań automatycznej synchronizacji czasu - większość ludzi raczej woli mieć aktualny czas ;)
- wyłączenie zadań automatycznej aktualizacji aplikacji pobraqnych ze sklepu MS - jeśli nie korzysztasz z takich aplikacji, możesz śmiało usunąć REM na początku tej linijki.

![image](https://user-images.githubusercontent.com/51444728/219337913-aac40b37-e56e-414c-b9a5-f2d05eaec300.png)
![image](https://user-images.githubusercontent.com/51444728/219338835-ddaa80e1-1855-4950-bfb9-409775436e06.png)
