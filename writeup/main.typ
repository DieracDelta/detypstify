#import "@preview/tablex:0.0.8": cellx, hlinex, tablex
#import "neurips2023.typ": *
#import "logo.typ": LaTeX, LaTeXe, TeX

#let yale = (department: none, institution: "Yale", location: none)
#let affls = ("yale": yale)

#let authors = (
  (name: "Justin Restivo",
   affl: "yale",
   email: "justin.restivo@yale.edu",
   equal: true),
  (name: "Jachym Putta",
   affl: "yale",
   email: "jachym.putta@yale.edu",
   equal: true),
)

#show: neurips2023.with(
  title: "Detypstify: OCR for formula generation",
  authors: (authors, affls),
  keywords: ("Machine Learning", "NeurIPS"),
  // one paragraph only
  abstract: [
    Something about im2latex, openai, OCR
  ],
  bibliography: bibliography("main.bib"),
  bibliography-opts: (title: "References", full: true),  // Only for example paper.
  accepted: true,
)

= Introduction
  Optical Character Recognition (OCR) has seen widespread use in the past few years. It has been used for data entry automation,
  document management, and even in the medical field for digitizing medical records. OCR makes the tasks both faster and less 
  error prone. In this paper, we present Detypstify, a tool which uses state-of-the-art OCR to generate math formulas from images.
  The problem of generating LaTeX formulas from images is not new, in fact it forms the basis of the OpenAI Im2Latex problem which 
  was posted as part of the first request for research @openai. Detypstify tackles this problem in a new way by using a transformer
  based model. We deploy this model using Web Assembly and WGPU to allow for client side computation. 

= Background and Related Work
  == Model
  Fine tuning of large models has proven to be an effective way of achieving 
  state-of-the-art performance on a wide range of tasks @finetuning-good2. This
  performance is often better than smaller models dedicated to this particular task @finetuning-good1.
  As a result, we decided to fine-tune a large model for our task as well. 

  Text recognition is usually done either with Convolutional Neural Networks (CNN) or with Recurrent Neural Networks (RNN). 
  We decided to diverge from the conventional approach and use a transformer based model. TrOCR @trocr, transformer based
  optical character recognition, is a model which outperforms the state-of-the-art in OCR tasks, both handwritten and printed.
  As such we decided to use this model as our base model for fine tuning. 

  == Other formula generation tools
  While there are several other tools which implement the same functionality as Detypstify, Detyptify has several features which
  distinguish it from the competition. 
  + *Support for Typst*, there are no tools which generate typst formulas from images.
  + *Web Assembly*, Detypstify is deployed using Web Assembly which allows it to be statically deployed
    and perform the computation on the client side which we haven't seen in other tools.
  + *Transofrmer based OCR*, most tools use CNN or RNN based OCR, Detypstify uses a transformer based OCR. //TODO: GET concrete citations on what other people use
  
  // FIXME: What do these sections mean?
  // == Machine Learning
  // == Algorithm

== Method description
  == Model
    === Dataset
    At the time of writing, there were no available datasets of images of formulas and their corresponding Typst 
    encoding. We created our own dataset by converting the formulas from the Im2Latex dataset @dataset which has 
    been widely used for similar tasks when converting to LaTeX. The bulk of the conversion was done using Pandoc,
    however, the conversion was not perfect and required several correction passes to ensure valid Typst formulas.
    This was because, to our knowledge, none of the datasets were generated post-Latex2e which led to several 
    incompatibilities with Pandoc. The final dataset is available on Kaggle @typst-dataset.
    === Training
    We fine tuned the TrOCR model on our dataset using native PyTorch with the VisionEncoderDecorerModel class.
    The model was trained on a single Nvidia GeForce RTX 4090 GPU for 7 epochs with a batch size of 1 because of 
    memory constraints. To evalutate the model we use the Character Error Rate (CER) which is the number of incorrect
    characters divided by the total number of characters. 

  == Webapp
    == ONNX
    ONNX is a widely used format for representing machine learning models. We export our trained model to ONNX so that
    we can integrate it with the rest of the application.
    == Burn
    Burn is a machine learning framework written in Rust, compatible with the ONNX model format. Burn is in active development
    and some of the necessary operations of the ONNX framework were not supported (expand, slice, squeeze, range, less,
    constantofshape). We confirmed with the developers of Burn that these operations were not supported and they are working
    to add support for them, as such we will integrate the model with the rest of the framework in the future.
    == Wasm + WGPU
    One of the main draws of using Web Assembly is the ability to run machine learning models in the browser on the client
    side. This means that we are not required to host a backend and can simple host the entire binary statically.
    //TODO: talk about WGPU
    To compliment this portability, we use WGPU, a Rust library for interfacing with the GPU. This allows us to run the model
    on arbitrary hardware and ensures that the model runs as fast as possible. 
= Results & Discussion
  == Model
  == Webapp


= Conclusion
We present Detypstify a tool that uses OCR for formula generation, we fine tune a transformer based large model for
this task and deploy it statically using Web Assembly and WGPU.
//TODO: summarize results
We hope that this tool will be useful for the Typst community.

#pagebreak()

