# Pokemon
寶可夢列表以及每個寶可夢的詳細資料

# Framework
使用CocoaPods來管理第三方的Framework
使用到的有:
1. SnapKit: 幫忙建置UIKit的自動佈局
2. SDWebImage: 幫忙非同步的下載網路圖片

# A. 關於本專案
本專案使用Storyboard建置基本UI，在一些需要即時UI變動的位置用SnapKit來更改元件的自動佈局架構上使用MVVM，所以每一個ViewController都各自持有自己的ViewModel，所有API的回傳資料都以struct的方式定義在PokemonData.swift檔案裡，API的非同步主要使用Swift concurrency來完成，API Error handle的部分因為時間因素無特別設計，建立了幾個Helper來幫忙完成此專案
1. APIHelper:
    1. 幫忙發出API並取得資料，型別定義為actor而不是class來避免data race的發生
2. DetailDataHelper:
    1. 當外部需要取用某寶可夢Detail資料時，會幫忙檢查是否已經緩存該資料，有的話直接取用，沒有的話就發動API去取得，並同時存成緩存緩存功能透過UserDefaults來實現，並且設計了該筆緩存資料超過一天就會被刪除重抓的機制
3. OwnedHelper:
    1. 在Detail頁使用者可以將特定寶可夢設為Owned或Unowned，並透過UserDefaults來將資料儲存
4. ShowAlertHelper:
    1. 顯示Alert

開啟App後，首先會進入HomeViewControler頁面：

# B. 進入HomeViewControler後
1. HomeViewControler持有的HomeViewModel會馬上呼叫函式loadPokemonList()去發出API來抓取第一筆寶可夢列表的資料
2. 資料取得並整理完成後透過閉包updateUIClosure告訴VC可以更新畫面了
3. VC利用資料showedDatas去生成或更新相對應數量的listCollectionView的cells
4. 各cell持有的CollectionViewCellViewModel會透過DetailDataHelper(A.2)的幫忙去發出API來抓取該寶可夢Detail的資料(API的URL由B.1的回傳得到)
5. 取得寶可夢Detail的資料即可透過cell來顯示下列四個基本資料給使用者看:
    1. Pokemon ID (in National Pokédex)
    2. Name
    3. Types
    4. Thumbnail image
6. 往下滑動接近最底層時會觸發自動抓下一頁的函式checkIfNeedloadNextPage(row: Int)，並抓取下一筆資料(API的URL為B.1的API URL加上offset跟limit參數得到)
7. 抓取到的新資料跟原資料合併後會再次更新UI(也就是B.2~B.5)
8. 發現當ID超過1025後，後面的ID會突然變成超過10000，且展示的是特別型態的寶可夢(Ex: Mega進化的寶可夢)，題目要的是記錄在寶可夢夢圖鑑裡的，所以ID超過1025的資料過濾掉不會顯示
9. 點擊listCollectionView的cell會進入DetailViewControler並將該寶可夢Detail的資料傳入

# C. 進入DetailViewControler後
1. DetailViewController持有的DetailViewModel會透過該寶可夢Detail的資料來更新UI，透過此資料能顯示的有:
    1. Pokemon ID
    2. Name
    3. Types
    4. Images (both male and female if available)
    5. Base stats
2. 呼叫DetailViewModel的isOwned函式會請OwnedHelper(A.3)提供資料來更新OwnedButton的UI
3. DetailViewModel呼叫函式(loadDescriptionAndEvolution)，由Detail資料取得species API的URL，由此發出API來取得Description的資料，並更新在UI上
4. Description text的語言UI有符合題目的描述: Description text in either Chinese (when the system is set to Traditional Chinese) or English (when the system is set to any other language).
5. C-2的API會同時回傳Evolution Chain的URL，由此來呼叫函式getEvolution發出Evolution Chain的API
6. 獲得Evolution Chain的資料之後，會呼叫函式loopToFindEvolutions並透過DetailDataHelper(A.2)來幫忙檢查Evolution Chain裡的寶可夢是否全部都有緩存的Detail資料，如果沒有就下如B.4的API去抓
7. 等到Evolution Chain資料都齊全之後，更新UI資料
8. UI最下方有Owned按鈕，點擊後會透過OwnedHelper(A.3)來存取或更新Owned的狀態，並更新UI

# D. 加分項目
1. Writing unit tests: 
   1. 建立了一個測試項目HomeViewModelTests來測試HomeViewModel裡面的所有函式
      1. testLoadPokemonList
      2. loadPokemonList
      3. testChangeOwnedMode
   2. 建立了另一個測試項目DetailViewModelTests來測試DetailViewModel裡面的所有函式
      1. testLoadDescriptionAndEvolution
      2. testIsOwned
      3. testChangeOwnedStatus
2. Writing UI tests: 
   建立了一個測試項目OwnedButtonUITests來測試，測試步驟是：
   1. 開啟App
   2. 進入HomeViewControler
   3. 點擊第一個cell進入DetailViewControler
   4. 點擊Ownded button
   5. 按鈕文字有變更即算成功
3. Implementing dependency injection: 
   1. HomeViewModel在初始化的時候可以自由注入符合特定Protocol規定的實體，可以注入的有
      1. APIHelperProtocol
      2. OwnedHelperProtocol
   2. DetailViewModel在初始化的時候可以自由注入符合特定Protocol規定的實體，可以注入的有
      1. APIHelperProtocol
      2. OwnedHelperProtocol
      3. DetailDataHelperProtocol
   實際上就是利用此設計來做出APIHelper, OwnedHelper和DetailDataHelper的Mock，進而實現HomeViewModel跟DetailViewModel的Unit Test
4. Adding the ability to switch between List and Grid views for the Pokemon List: 
   1. 可以點擊左上角的Show grid切換list跟grid模式，主要是在同一個listCollectionView中
      切換ListCollectionViewCell跟GridCollectionViewCell兩個不同的cell
5. Implementing local caching of data for faster app loading: 
   1. 由A.2的DetailDataHelper來實作此功能，細節已經寫在裡面
6. Implement additional functionality to select two types simultaneously and display attack multipliers (4x, 2x, 1/2x, 1/4x, 0x): 
   1. 這一題因時間不足放棄
7. Allowing users to view all Pokemon of a selected type in type matchup chart and access their details: 
   1. 這一題因時間不足放棄
8. Utilizing LLM tools and documenting how they were used in the README: 
   1. 沒有使用LLM工具
