// https://www.lagou.com/gongsi/allCity.html


$$('.word_list tr').reduce(function(arr, e){
  var capital = e.querySelector('.word').innerText;
  var row = $(e.querySelectorAll('.city_list li')).map(function(ee) {
      var city = this.innerText
      var url = this.querySelector('a').href
      var id = gainId(url)
      return {city, id}
    })
  row = [].slice.apply(row)
  return arr.concat(row)
}, [])

function gainId(url) {
  var pat = /(https:)?\/\/www.lagou.com\/gongsi\/([\d]+)-0-0/i
  var matches = url.match(pat)
  return matches[2]
}


