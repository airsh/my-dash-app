const API_URL = "https://e4fza43f29.execute-api.ap-northeast-1.amazonaws.com/prod"; // API Gateway のURL

fetch(API_URL)
  .then(response => response.json())  // JSONとしてデコード
  .then(data => {
    console.log("Raw API Response:", data);  // デバッグ用にAPIレスポンスを表示

    // もし data.body が文字列なら JSON に変換
    let parsedData = typeof data.body === "string" ? JSON.parse(data.body) : data;

    console.log("Parsed Data:", parsedData);  // デバッグ用

    let trace = {
      x: parsedData.map(d => parseFloat(d.GDP)),  // GDP を数値に変換
      y: parsedData.map(d => parseFloat(d.LifeExpectancy)),  // 平均寿命を数値に変換
      text: parsedData.map(d => d.Country),  // ホバー時の国名
      mode: 'markers',
      marker: { size: 10 },
      type: 'scatter'
    };

    let layout = {
      title: "GDP vs Life Expectancy",
      xaxis: { title: "GDP per Capita" },
      yaxis: { title: "Life Expectancy" }
    };

    Plotly.newPlot('plot', [trace], layout);
  })
  .catch(error => console.error("Error fetching data:", error));

